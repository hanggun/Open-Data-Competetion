import tensorflow as tf
import config
from processor import Processor
import tools
from model import DGCNN
import numpy as np
import os
os.environ['CUDA_VISIBLE_DEVICES'] = '-1'

class Predict:
    def __init__(self):
        p = Processor()
        self.vocab = tools.read_txt(config.vocab_dir)
        self.vocab2id, _ = tools.convert_vocab(self.vocab)
        self.model = DGCNN()
        self.model.load_weights(config.weights_dir)
        labels = p.get_labels()
        self.id2label = {id:label for id, label in enumerate(labels)}

    def __call__(self, texts):
        examples = []
        for text in texts:
            examples.append(tools.clean_cn_char(text))
        examples = tools.convert_tokens_to_ids(examples, self.vocab2id, config.seqlen, oov_index=self.vocab2id['[OOV]'],
                                               pad=True)
        dataloader = tf.data.Dataset.from_tensor_slices(examples).batch(config.batch_size)
        total_pred1 = []
        total_pred2 = []
        for examples in dataloader:
            pred1, pred2 = self.model(examples)
            total_pred1.extend(pred1.numpy().tolist())
            total_pred2.extend(pred2.numpy().tolist())
        total_pred1 = np.argmax(total_pred1, axis=1).tolist()
        total_pred2 = np.argmax(total_pred2, axis=1).tolist()
        total_pred1 = [self.id2label[x] for x in total_pred1]
        total_pred2 = [self.id2label[x+3] for x in total_pred2]
        return total_pred1, total_pred2

if __name__ == '__main__':
    p = Predict()
    print(p(['我的家乡']))
