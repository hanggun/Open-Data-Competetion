import 'package:business_mining/bean/news_bean.dart';
import 'package:business_mining/common/color.dart';
import 'package:business_mining/demo/news/detail/news_detail_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nav_router/nav_router.dart';

import '../company_detail_route.dart';

///企业详情内部的新闻条目
// ignore: must_be_immutable
class ItemCompanyNewsWidget extends StatelessWidget {
  NewsBean bean;
  Color bgColor;
  Function onTap;

  ItemCompanyNewsWidget(
    this.bean, {
    this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var paddingTop6 = Padding(padding: EdgeInsets.only(top: 6));
    var paddingTop8 = Padding(padding: EdgeInsets.only(top: 8));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Material(
        color: bgColor ?? Color(0xFFF9FBFC),
        child: InkWell(
          onTap: () {
            routePush(NewsDetailRoute(bean));
            onTap?.call();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    "${bean.sourceTwo ?? bean.sourceOne ?? ""}  ${bean.publishTime?.substring(0, 10) ?? ""}"),
                paddingTop6,
                Text(
                  "${bean.title}",
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: TextColor.textBlack,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        letterSpacing: 1.01,
                      ),
                ),
                paddingTop6,
                Text(
                  "${bean.abstract}",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: TextColor.textGrayLight, fontSize: 13, height: 1.6),
                ),
                bean.matchCompanyList == null || bean.matchCompanyList.isEmpty
                    ? Text("五")
                    : Container(
                        height: 48,
                        padding: EdgeInsets.only(top: 8),
                        child: ListView.builder(
                            itemCount: bean.matchCompanyList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              var matchCompany = bean.matchCompanyList[index];
                              return InkWell(
                                onTap: () =>
                                    routePush(CompanyDetailRoute(id: matchCompany.companyId)),
                                child: Container(
                                  margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
                                  color: Color(0xFFECF4FE),
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Center(
                                    child: Text(
                                      "${matchCompany.companyName}",
                                      style: TextStyle(color: TextColor.textBlack, fontSize: 12),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                paddingTop8,
                Row(
                  children: _buildRow(),
                ),
                paddingTop8,
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildRow() {
    List<Widget> result;
    if (bean.topicWords != null || (bean.topicWords?.isNotEmpty ?? false)) {
      result = bean.topicWords
          .split(",")
          .map<Widget>((e) => Padding(padding: EdgeInsets.only(right: 18), child: Text("#${e}")))
          .toList();
    } else {
      result = List();
    }
    result.add(Expanded(
      child: Text(
        "查看原文",
        textAlign: TextAlign.right,
        style: TextStyle(color: Color(0xFF388CF1), fontSize: 13),
      ),
    ));
    return result;
  }
}
