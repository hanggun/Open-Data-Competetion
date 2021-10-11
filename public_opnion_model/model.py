from tensorflow.keras.layers import Conv1D, Dense, Layer, LayerNormalization, Dropout, Embedding
import tensorflow as tf
import tensorflow.keras.backend as K
import config


class ResidualGatedConv1D(Layer):
    """门控卷积
    """
    def __init__(self, filters, kernel_size, dilation_rate=1, **kwargs):
        super(ResidualGatedConv1D, self).__init__(**kwargs)
        self.filters = filters
        self.kernel_size = kernel_size
        self.dilation_rate = dilation_rate
        self.supports_masking = True

    def build(self, input_shape):
        super(ResidualGatedConv1D, self).build(input_shape)
        self.conv1d = Conv1D(
            filters=self.filters * 2,
            kernel_size=self.kernel_size,
            dilation_rate=self.dilation_rate,
            padding='same',
        )
        self.layernorm = LayerNormalization()

        if self.filters != input_shape[-1]:
            self.dense = Dense(self.filters, use_bias=False)

        self.alpha = self.add_weight(
            name='alpha', shape=[1], initializer='zeros'
        )

    @tf.function
    def call(self, inputs, mask=None):
        if mask is not None:
            mask = K.cast(mask, K.floatx())
            inputs = inputs * mask[:, :, None]

        outputs = self.conv1d(inputs)
        gate = K.sigmoid(outputs[..., self.filters:])
        outputs = outputs[..., :self.filters] * gate
        outputs = self.layernorm(outputs)

        if hasattr(self, 'dense'):
            inputs = self.dense(inputs)

        return inputs + self.alpha * outputs

    def compute_output_shape(self, input_shape):
        shape = self.conv1d.compute_output_shape(input_shape)
        return (shape[0], shape[1], shape[2] // 2)

    def get_config(self):
        config = {
            'filters': self.filters,
            'kernel_size': self.kernel_size,
            'dilation_rate': self.dilation_rate
        }
        base_config = super(ResidualGatedConv1D, self).get_config()
        return dict(list(base_config.items()) + list(config.items()))


class AttentionPooling1D(tf.keras.layers.Layer):
    """通过加性Attention，将向量序列融合为一个定长向量
    """
    def __init__(self):
        super(AttentionPooling1D, self).__init__()
        self.k_dense = Dense(config.embedding_size, use_bias=False, activation='tanh')
        self.o_dense = Dense(1, use_bias=False)

    @tf.function
    def call(self, inputs):
        x = inputs
        x = self.k_dense(x)
        x = self.o_dense(x)
        x = K.softmax(x, 1)
        return K.sum(tf.multiply(x, inputs), 1)


class DGCNN(tf.keras.Model):
    def __init__(self):
        super().__init__()
        self.embedding = Embedding(config.vocab_size, config.embedding_size, mask_zero=True, input_length=256)
        self.drop1 = Dropout(0.1)
        self.drop2 = Dropout(0.1)
        self.drop3 = Dropout(0.1)
        self.drop4 = Dropout(0.1)
        self.drop5 = Dropout(0.1)
        self.drop6 = Dropout(0.1)
        self.drop7 = Dropout(0.1)
        self.drop8 = Dropout(0.1)
        self.class1 = Dense(config.num_class1, activation='softmax')
        self.class2 = Dense(config.num_class2, activation='softmax')
        self.rgc11 = ResidualGatedConv1D(config.embedding_size, 3, dilation_rate=1)
        self.rgc12 = ResidualGatedConv1D(config.embedding_size, 3, dilation_rate=1)
        self.rgc13 = ResidualGatedConv1D(config.embedding_size, 3, dilation_rate=1)
        self.rgc2 = ResidualGatedConv1D(config.embedding_size, 3, dilation_rate=2)
        self.rgc4 = ResidualGatedConv1D(config.embedding_size, 3, dilation_rate=4)
        self.rgc8 = ResidualGatedConv1D(config.embedding_size, 3, dilation_rate=8)
        self.ap = AttentionPooling1D()

    @tf.function
    def __call__(self, inputs):

        x = self.embedding(inputs)
        x = self.drop1(x)
        x = self.rgc11(x)
        x = self.drop2(x)
        x = self.rgc2(x)
        x = self.drop3(x)
        x = self.rgc4(x)
        x = self.drop4(x)
        x = self.rgc8(x)
        x = self.drop5(x)
        x = self.rgc12(x)
        x = self.drop6(x)
        x = self.rgc13(x)
        x = self.drop7(x)
        x = self.ap(x)
        drop_x = self.drop8(x)
        x1 = self.class1(drop_x)
        x2 = self.class2(drop_x)

        return x1, x2
