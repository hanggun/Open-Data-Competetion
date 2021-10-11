import 'dart:collection';

import 'package:business_mining/bean/demo_company_bean.dart';
import 'package:business_mining/bean/demo_risk_bean.dart';
import 'package:business_mining/bean/news_bean.dart';
import 'package:business_mining/common/global.dart';
import 'package:business_mining/provider/view_state_page_list_model.dart';
import 'package:dio/dio.dart';

import 'api_service.dart';

class ApiDemo {
  static const int pageSize = ViewStatePageListModel.pageSize;

  ///企业搜索
  static Future<List<DemoCompanyBean>> searchCompany({String content, int page}) async {
    try {
      var formData = FormData.fromMap({
        'keyword': content,
        'page_index': page * pageSize,
        'page_size': pageSize,
      });
      var response = await https.post("/search_company", data: formData);

      List<dynamic> list = response.data;
      return list.map((e) => DemoCompanyBean.fromJson(e)).toList();
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  ///根据企业id查询企业详情
  static Future<DemoCompanyBean> queryCompanyById(String id) async {
    var hashMap = new HashMap<String, dynamic>();
    hashMap["company_id"] = id;

    var response = await https.post("/company_info", data: FormData.fromMap(hashMap));
    var companyBean = DemoCompanyBean.fromJson(response.data);
    return companyBean;
  }

  ///推荐
  static Future<List<DemoCompanyBean>> queryRecommend(id) async {
    try {
      var formData = FormData.fromMap({
        'company_id': id,
      });
      var response = await https.post("/recommend_company", data: formData);

      List<dynamic> list = response.data;
      return list.map((e) => DemoCompanyBean.fromJson(e)).toList();
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  ///推荐
  static Future<List<NewsBean>> queryNews(id, page) async {
    try {
      var formData = FormData.fromMap({
        'company_id': id,
        'page_index': page * pageSize,
        'page_size': pageSize,
      });
      var response = await https.post("/news_list", data: formData);

      List<dynamic> list = response.data;
      return list.map((e) => NewsBean.fromJson(e)).toList();
    } catch (e) {
      logger.e(e);
      return [];
    }
  }

  ///推荐
  static Future<DemoRiskBean> queryRiskDetail(id) async {
    try {
      var formData = FormData.fromMap({
        'company_id': id,
      });
      var response = await https.post("/business_valuation", data: formData);

      return DemoRiskBean.fromJson(response.data);
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}
