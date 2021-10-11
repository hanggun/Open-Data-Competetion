import tools
import config
import os
from processor import Processor
import tensorflow as tf
from model import DGCNN
import time
from tqdm import tqdm


p = Processor()
train_examples = p.get_train_examples(config.train_dir)
dev_examples = p.get_dev_examples(config.val_dir)
if not os.path.exists(config.vocab_dir):
    texts, _ = zip(*(train_examples+dev_examples))
    vocab, _ = tools.get_vocab(texts, config.vocab_size, special_tokens=['[PADDING]', '[OOV]'])
    tools.save_txt(vocab, config.vocab_dir)
else:
    vocab = tools.read_txt(config.vocab_dir)
vocab2id, id2vocab = tools.convert_vocab(vocab)

train_data = tools.convert_examples_to_features_multilabel(train_examples, p.get_labels(), config.seqlen, vocab2id,
                                                vocab2id['[PADDING]'], vocab2id['[OOV]'])
dev_data = tools.convert_examples_to_features_multilabel(dev_examples, p.get_labels(), config.seqlen, vocab2id,
                                              vocab2id['[PADDING]'], vocab2id['[OOV]'])
train_dataloader = tf.data.Dataset.from_tensor_slices(train_data).shuffle(len(train_data)).batch(config.batch_size)
dev_dataloader = tf.data.Dataset.from_tensor_slices(dev_data).batch(config.batch_size)


if __name__ == '__main__':
    model = DGCNN()
    optimizer = tf.keras.optimizers.Adam(learning_rate=0.001)

    @tf.function
    def my_gradient(X, y1, y2):
        with tf.GradientTape() as tape:
            y_pred1, y_pred2 = model(X)
            loss1 = tf.keras.losses.categorical_crossentropy(y_true=y1, y_pred=y_pred1)
            loss2 = tf.keras.losses.categorical_crossentropy(y_true=y2, y_pred=y_pred2)
            loss = tf.reduce_mean(loss1) + tf.reduce_mean(loss2)
        grads = tape.gradient(loss, model.trainable_variables)
        optimizer.apply_gradients(grads_and_vars=zip(grads, model.trainable_variables))
        return loss

    best_dev = 0
    for epoch in range(1, config.epochs + 1):
        print('epoch %d/%d' % (epoch, config.epochs))
        time.sleep(0.5)
        pbar = tqdm(enumerate(train_dataloader, 1))
        total_loss = 0
        for idx, (X, y1, y2) in pbar:
            loss = my_gradient(X, y1, y2)
            total_loss = (loss.numpy() - total_loss) / idx + total_loss
            pbar.set_description("loss %f" % (total_loss))

        categorical_accuracy1 = tf.keras.metrics.CategoricalAccuracy()
        categorical_accuracy2 = tf.keras.metrics.CategoricalAccuracy()
        # categorical_accuracy1.reset_states()
        # categorical_accuracy2.reset_states()
        for X, y1, y2 in dev_dataloader:
            y_pred1, y_pred2 = model(X)
            categorical_accuracy1.update_state(y_true=y1, y_pred=y_pred1)
            categorical_accuracy2.update_state(y_true=y2, y_pred=y_pred2)
            if categorical_accuracy1.result() > best_dev:
                model.save_weights(config.weights_dir)
        print("dev accuracy: %f, %f" % (categorical_accuracy1.result(), categorical_accuracy2.result()))