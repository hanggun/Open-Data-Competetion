import 'package:business_mining/bean/news_bean.dart';
import 'package:flutter/widgets.dart';

class NewsDetailModel with ChangeNotifier {
  NewsBean bean;

  NewsDetailModel(this.bean) {
    queryNewsDetailById();
  }

  queryNewsDetailById() async {
    try {
      notifyListeners();
    } catch (e) {}
  }
}
