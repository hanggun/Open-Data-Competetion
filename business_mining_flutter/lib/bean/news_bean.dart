/// abstract : "厂-包装A线D线新增撑箱机自动上纸板设备招标公告  发布日期：2020年07月07日  附件下载:下"
/// bids_id : "186036350"
/// city : "宁波"
/// companyName : "华润雪花啤酒（中国）有限公司浙江销售分公司"
/// deadline : null
/// province : "浙江"
/// publish_time : "2020-07-08 08:07:50"
/// title : "华润雪花啤酒（中国）有限公司浙江销售分公司浙江-2020-常规-宁波工厂-包装A线D线新增撑箱机自动上纸板设备招标公告"
/// type : "招标公告"

class NewsBean {
  static const String EMOTION_ALL = "全部";

  ///正面
  static const String EMOTION_GOOD = "正面";

  ///负面
  static const String EMOTION_BAD = "负面";

  ///中性
  static const String EMOTION_NEUTRAL = "中性";

  ///_id,id,news_id,bids_id
  String id;
  String abstract;
  String city;
  String companyName;
  String deadline;
  String province;
  String publishTime;
  String title;
  String type;
  String categoryLabel;
  String createTime;
  String elements;
  String emotionResult;
  List<MatchCompanyList> matchCompanyList;
  String newsCategory;
  String sourceOne;
  String sourceTwo;
  String sourceTwoLogo;
  String topicWords;
  String url;
  bool usefulStatus;
  bool collectStatus;

  ///仅仅在消息中使用
  String pushTime;

  NewsBean({
    this.abstract,
    this.id,
    this.city,
    this.companyName,
    this.deadline,
    this.province,
    this.publishTime,
    this.title,
    this.type,
    this.categoryLabel,
    this.createTime,
    this.elements,
    this.emotionResult,
    this.matchCompanyList,
    this.newsCategory,
    this.sourceOne,
    this.sourceTwo,
    this.sourceTwoLogo,
    this.topicWords,
    this.url,
    this.usefulStatus,
    this.collectStatus,
    this.pushTime,
  });

  NewsBean.fromJson(dynamic json) {
    abstract = json["abstract"];
    id = json["_id"] ?? json["id"] ?? json["news_id"];
    city = json["city"];
    companyName = json["companyName"] ?? json["company_name"];
    deadline = json["deadline"];
    province = json["province"];
    publishTime = json["publishTime"];
    title = json["title"];
    type = json["type"];
    categoryLabel = json["category_label"];
    createTime = json["create_time"];
    elements = json["elements"];
    emotionResult = json["emotion_result"];
    if (json["match_company_list"] != null && json["match_company_list"] is Map) {
      matchCompanyList = [];
      json["match_company_list"].forEach((v) {
        matchCompanyList.add(MatchCompanyList.fromJson(v));
      });
    }
    newsCategory = json["news_category"];
    publishTime = json["publish_time"];
    sourceOne = json["source_one"];
    sourceTwo = json["source_two"];
    sourceTwoLogo = json["source_two_logo"];
    title = json["title"];
    topicWords = json["topic_words"];
    url = json["source_url"] ?? json['news_url'];
    usefulStatus = json["useful_status"];
    collectStatus = json["collect_status"];
    pushTime = json["push_time"];
  }

  @override
  String toString() {
    return 'NewsBean{id: $id, abstract: $abstract, city: $city, companyName: $companyName, deadline: $deadline, province: $province, publishTime: $publishTime, title: $title, type: $type, categoryLabel: $categoryLabel, createTime: $createTime,emotionResult: $emotionResult, matchCompanyList: $matchCompanyList, newsCategory: $newsCategory, sourceOne: $sourceOne, sourceTwo: $sourceTwo, sourceTwoLogo: $sourceTwoLogo, topicWords: $topicWords, url: $url}';
  }
}

/// company_id : "913300007042034718"
/// company_name : "浙江五芳斋实业股份有限公司"

class MatchCompanyList {
  String companyId;
  String companyName;

  MatchCompanyList({this.companyId, this.companyName});

  MatchCompanyList.fromJson(dynamic json) {
    companyId = json["company_id"];
    companyName = json["company_name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["companyId"] = companyId;
    map["companyName"] = companyName;
    return map;
  }
}
