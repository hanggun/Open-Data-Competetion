import cpca
import pymongo
from tqdm import tqdm
import re
import tools
from selectolax.parser import HTMLParser
from bs4 import BeautifulSoup
from pyquery import PyQuery as pq

def get_data():
    col = pymongo.MongoClient('mongodb://10.0.102.72:27017')['search_']
    mydb = col['news_item']

    target_json = []
    target_txt = []
    for item in tqdm(mydb.find().batch_size(500)):
        text = item['text']
        text = re.sub(r'\s+', '', text)
        company = item['search_company']
        original_company = company
        company_res = cpca.transform([company], pos_sensitive=True)
        company = company_res.iloc[0,3]
        if not company:
            company = original_company
        if re.search('集团公司|有限公司', company[-4:]):
            company = company[:-4]
        if re.search('集团|公司', company[-2:]):
            company = company[:-2]
        assert company in original_company
        if company in text:
            target_json.append({'text': text, 'original_company': original_company, 'company': company})
            target_txt.append(text)

    tools.save_json(target_json, 'data/target.json')
    tools.save_txt(target_txt, 'data/target.txt')


if __name__ == '__main__':
    get_data()
