import 'package:business_mining/bean/demo_company_bean.dart';
import 'package:business_mining/common/color.dart';
import 'package:business_mining/demo/company/detail/news/item_company_news_widget.dart';
import 'package:business_mining/demo/home/risk_info_route.dart';
import 'package:business_mining/net/api_demo.dart';
import 'package:business_mining/provider/local_profile_model.dart';
import 'package:business_mining/provider/provider_widget.dart';
import 'package:business_mining/provider/view_state_page_list_model.dart';
import 'package:business_mining/r.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nav_router/nav_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

import '../company_detail_route.dart';
import 'company_business_information_route.dart';
import 'company_detail_model.dart';

class CompanyDetailBasicWidget extends StatefulWidget {
  @override
  _CompanyDetailBasicWidgetState createState() => _CompanyDetailBasicWidgetState();
}

class _CompanyDetailBasicWidgetState extends State<CompanyDetailBasicWidget>
    with AutomaticKeepAliveClientMixin {
  RecommendCompanyListModel recommendCompanyListModel;
  _NewsModel _newsModel;

  @override
  void initState() {
    var id = Provider.of<CompanyDetailModel>(context, listen: false).companyBean?.id;
    recommendCompanyListModel = RecommendCompanyListModel(id);
    _newsModel = _NewsModel(id);
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Color(0xFFF8F8FA),
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: _buildHead(),
                  ),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    child: _buildBusinessInfo(),
                  ),
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                    height: 64,
                    child: _buildCompanyRecommend(),
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 8, left: 6, right: 6),
                    padding: EdgeInsets.only(top: 12, left: 12, right: 6),
                    child: Text(
                      '新闻舆情',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            )
          ];
        },
        body: Container(
          color: Colors.white,
          margin: EdgeInsets.only(bottom: 8, left: 6, right: 6),
          child: ProviderWidget<_NewsModel>(
              model: _newsModel,
              onModelReady: (model) => model.initData(),
              builder: (context, model, child) {
                return SmartRefresher(
                  physics: BouncingScrollPhysics(),
                  controller: model.refreshController,
                  onRefresh: model.refresh,
                  onLoading: model.loadMore,
                  enablePullUp: true,
                  child: ListView.builder(
                      itemCount: model.list?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ItemCompanyNewsWidget(model.list[index]);
                      }),
                );
              }),
        ),
      ),
    );
  }

  ///头部下方的企业基本信息
  Widget _buildBusinessInfo() {
    var bean = Provider.of<CompanyDetailModel>(context, listen: false).companyBean;
    var titleStyle = const TextStyle(color: TextColor.textGrayLight, fontSize: 12);
    var bodyStyle = const TextStyle(color: TextColor.textBlack, fontSize: 13);
    var paddingTop8 = const Padding(padding: const EdgeInsets.only(top: 8));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text("成立时间", style: titleStyle),
                paddingTop8,
                Text(bean?.establishDate?.replaceAll('00:00:00', '') ?? "", style: bodyStyle),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text("法人", style: titleStyle),
                paddingTop8,
                Text(bean?.legalRepresentative ?? "", style: bodyStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///生成头部ui
  _buildHead() {
    var bean = Provider.of<CompanyDetailModel>(context, listen: false).companyBean;
    var companyName = bean?.companyName;
    String companyNameFirst4;
    if (companyName != null && companyName.length >= 4) {
      companyNameFirst4 = companyName.substring(0, 2) + "\n" + companyName.substring(2, 4);
    }
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 12, right: 8, bottom: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                color: Color(0x1D388CF1),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  companyNameFirst4 ?? "",
                  style: TextStyle(color: Color(0xFF388CF1), fontSize: 12),
                ),
              ),
              Padding(padding: EdgeInsets.only(left: 12)),
              Expanded(
                child: Hero(
                  tag: 'company${bean.id}',
                  child: Text(
                    companyName ?? "",
                    maxLines: 1,
                    style: TextStyle(
                        color: TextColor.textBlack, fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          Row(
            children: <Widget>[
              Container(
                color: const Color(0x1D68B483),
                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                child: Text(
                  "${bean?.industryCategory ?? ""}",
                  style: TextStyle(fontSize: 11, color: Color(0xFF68B483)),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              SvgPicture.asset(R.svgPhone, width: 12, height: 12),
              Padding(padding: EdgeInsets.only(left: 6)),
              Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () => launch('tel:${bean?.telephone ?? ""}'),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14, bottom: 16),
                    child: Text(
                      "企业电话 ${bean?.telephone ?? ""}",
                      style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(padding: const EdgeInsets.only(top: 8)),
          Row(
            children: <Widget>[
              SvgPicture.asset(R.svgLocation, width: 12, height: 12),
              Padding(padding: EdgeInsets.only(left: 6)),
              Expanded(
                child: Text(
                  "${bean?.registeredAddress ?? ''}",
                  style: TextStyle(fontSize: 12, color: TextColor.textGrayLight),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: DefaultTextStyle(
              style: TextStyle(
                fontSize: 11,
                color: TextColor.textBlack,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () => routePush(CompanyBusinessInformationRoute(bean)),
                      child: Padding(
                        padding: EdgeInsets.only(top: 24, right: 0, left: 0, bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(R.svgCompanyScope, width: 48),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Text("工商信息"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => _showCompanyIntroduceDialog(bean),
                      child: Padding(
                        padding: EdgeInsets.only(top: 24, right: 0, left: 0, bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(R.svgArchitecture, width: 48),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Text("公司介绍"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => routePush(RiskInfoRoute(id: bean?.id)),
                      child: Padding(
                        padding: EdgeInsets.only(top: 24, right: 0, left: 0, bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(R.svgRelation, width: 48),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Text("风险信息"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///推荐企业ui
  Widget _buildCompanyRecommend() {
    return ProviderWidget<RecommendCompanyListModel>(
      model: recommendCompanyListModel,
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        return InkWell(
          onTap: () {
            if (model.bean == null || model.bean.id == null) {
              return;
            }
            routePush(CompanyDetailRoute(bean: model.bean));
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                R.imgRecommend,
                width: 80,
                fit: BoxFit.contain,
              ),
              Padding(padding: EdgeInsets.only(left: 12)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      model.bean?.companyName ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: TextColor.textBlack, fontSize: 14),
                    ),
                    Padding(padding: EdgeInsets.only(top: 2)),
                    Text(
                      "${model.bean?.legalRepresentative ?? ""} · ${model.bean?.establishDate?.replaceAll("00:00:00", "") ?? ""}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: TextColor.textGrayLight, fontSize: 10),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: TextColor.textGrayLight,
                size: 20,
              ),
            ],
          ),
        );
      },
    );
  }

  ///公司介绍底部对话框
  _showCompanyIntroduceDialog(DemoCompanyBean bean) {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          var padding20 = Padding(padding: EdgeInsets.only(top: 20));
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                padding20,
                Center(
                  child: Text(
                    "公司介绍",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: TextColor.textBlack, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Text(
                    bean.businessScope,
                    style: TextStyle(color: TextColor.textBlackLight, fontSize: 13),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _NewsModel extends ViewStatePageListModel {
  final String id;

  _NewsModel(this.id) {
    initData();
  }

  @override
  Future<List> loadData({int pageNum}) async {
    return await ApiDemo.queryNews(id, pageNum);
  }
}
