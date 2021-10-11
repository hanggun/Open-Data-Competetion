import config
import tools
import json
from tqdm import tqdm

class Processor:
    def process_raw_file(self, file_path, subset):
        corpus_data = list()
        df = tools.read_json(file_path)
        id2label = {id:label for id,label in zip(range(314, 323), self.get_labels())}
        for line in tqdm(df):
            if not line['annotations']:
                continue
            text = line['text'][:600]
            sample_tokens = tools.clean_cn_char(text)
            label = [id2label[line['annotations'][0]['label']], id2label[line['annotations'][1]['label']]]
            corpus_data.append({'token': sample_tokens, 'label': label})

        return corpus_data

    def preprocess(self):
        train_corpus_data = self.process_raw_file(config.raw_json, 'train')
        tools.save_json(train_corpus_data, config.data_json)

    def split_data(self):
        train_corpus_data = tools.read_json(config.data_json)
        train, val = tools.data_split(train_corpus_data, random_state=42, test_size=0.2)
        tools.save_json(train, config.train_dir)
        tools.save_json(val, config.val_dir)

    def get_train_examples(self, data_path):
        return self._create_examples(
            open(data_path, 'r', encoding='utf-8'))

    def get_dev_examples(self, data_path):
        return self._create_examples(
            open(data_path, 'r', encoding='utf-8'))

    def get_test_examples(self, data_path):
        return self._create_examples(
            open(data_path, 'r', encoding='utf-8'))

    def get_labels(self):
        return ['pos', 'neg', 'neu', 'other', 'market', 'product', 'safety', 'management', 'law']

    def _create_examples(self, lines):
        examples = []
        for (i, line) in enumerate(lines):
            line = json.loads(line)
            token = line['token']
            label = line['label']
            examples.append((token, label))
        return examples


if __name__ == '__main__':
    p = Processor()
    p.preprocess()
    p.split_data()