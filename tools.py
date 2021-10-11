from collections import Counter
import json
import numpy as np
import sys
import re
from tqdm import tqdm

import config

sys.setrecursionlimit(1000000)

def save_json(data, output_path):
    with open(output_path, 'w', encoding='utf-8') as f:
        for line in data:
            f.write(json.dumps(line, ensure_ascii=False) + '\n')


def read_json(file):
    datasets = []
    with open(file, 'r', encoding='utf-8') as f:
        for line in f:
            datasets.append(json.loads(line))
    return datasets


def read_txt(file):
    datasets = open(file, 'r', encoding='utf-8').read().splitlines()
    return datasets


def save_txt(data, file):
    with open(file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(data))


def get_vocab(texts, vocab_length, special_tokens=None):
    counter = Counter()
    for line in texts:
        for word in line:
            counter[word] += 1
    vocab = counter.most_common(vocab_length)
    word, value = zip(*vocab)
    if special_tokens:
        word = special_tokens + list(word)
    return word, value


def convert_vocab(vocab):
    """
    :param vocab:
    :return: word2id, id2word
    """
    word2id = {word:id for id,word in enumerate(vocab)}
    id2word = {id:word for id,word in enumerate(vocab)}
    return word2id, id2word


def convert_examples_to_features(examples, label_list, max_seq_len, vocab2id, padding_index=0, oov_index=0):
    label_map = {label: i for i, label in enumerate(label_list)}

    input_ids, label_ids = [], []
    for (ex_index, example) in tqdm(enumerate(examples)):
        token = example[0]
        label = example[1]
        input_id = [vocab2id[x] if x in vocab2id else oov_index for x in token]
        if len(input_id) >= max_seq_len:
            input_id = input_id[:max_seq_len]
        else:
            input_id = input_id + [padding_index] * (max_seq_len - len(input_id))
        input_ids.append(input_id)
        label_id = label_map[label]
        label_ids.append(label_id)

    return input_ids, label_ids


def convert_examples_to_features_multilabel(examples, label_list, max_seq_len, vocab2id, padding_index=0, oov_index=0):
    label_map = {label: i for i, label in enumerate(label_list)}

    input_ids, label_ids1, label_ids2 = [], [], []
    for (ex_index, example) in tqdm(enumerate(examples)):
        token = example[0]
        label = example[1]
        input_id = [vocab2id[x] if x in vocab2id else oov_index for x in token]
        if len(input_id) >= max_seq_len:
            input_id = input_id[:max_seq_len]
        else:
            input_id = input_id + [padding_index] * (max_seq_len - len(input_id))
        input_ids.append(input_id)
        label_id1 = label_map[label[0]]
        label_id2 = label_map[label[1]] - 3
        label_ids1.append([label_id1])
        label_ids2.append([label_id2])

    from tensorflow.keras.utils import to_categorical
    return input_ids, to_categorical(label_ids1, config.num_class1), to_categorical(label_ids2, config.num_class2)


def convert_tokens_to_ids(tokens, word2id, max_len=None, pad_index=0, oov_index=0, pad=False):
    if not max_len:
        max_len = max([len(x) for x in tokens])
    sequence = []
    for text in tokens:
        tmp_seq = [word2id[x] if x in word2id else oov_index for x in text]
        if len(text) < max_len:
            if pad:
                tmp_seq += [pad_index] * (max_len - len(text))
        else:
            tmp_seq = tmp_seq[:max_len]
        sequence.append(tmp_seq)
    return np.array(sequence)


def sequence_padding(inputs, length=None, padding=0, mode='post'):
    """Numpy函数，将序列padding到同一长度
    """
    if length is None:
        length = max([len(x) for x in inputs])

    pad_width = [(0, 0) for _ in np.shape(inputs[0])]
    outputs = []
    for x in inputs:
        x = x[:length]
        if mode == 'post':
            pad_width[0] = (0, length - len(x))
        elif mode == 'pre':
            pad_width[0] = (length - len(x), 0)
        else:
            raise ValueError('"mode" argument must be "post" or "pre".')
        x = np.pad(x, pad_width, 'constant', constant_values=padding)
        outputs.append(x)

    return np.array(outputs)


def clean_cn_char(sample):
    chars = []
    re_han = re.compile(u"([\u4E00-\u9FD5a-zA-Z]+)")
    for word in sample:
        if re_han.match(word):
            chars.append(word)
    return chars


def clean_cn_words(sample):
    re_han = re.compile(u"([\u4E00-\u9FD5a-zA-Z]+)")
    blocks = re_han.split(sample.strip())
    tokens = []
    for blk in blocks:
        if re_han.match(blk):
            for w in jieba.cut(blk):
                tokens.append(w)
    return tokens


def data_split(data, random_state=42, test_size=0.1):
    from sklearn.model_selection import train_test_split

    def union(train_x, train_y):
        total = []
        for x,y in zip(train_x, train_y):
            total.append({'token': x, 'label': y})
        return total

    x, y = zip(*[(x['token'], x['label']) for x in data])
    train_x, val_x, train_y, val_y = train_test_split(x,y, test_size=test_size, random_state=random_state)
    train_data = union(train_x, train_y)
    val_data = union(val_x, val_y)
    return train_data, val_data