import 'package:business_mining/bean/demo_company_bean.dart';
import 'package:business_mining/net/api_demo.dart';
import 'package:business_mining/provider/provider_widget.dart';
import 'package:business_mining/provider/view_state_model.dart';
import 'package:business_mining/provider/view_state_widget.dart';
import 'package:business_mining/widget/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'basic/company_detail_basic_widget.dart';

class CompanyDetailRoute extends StatefulWidget {
  final String id;
  final DemoCompanyBean bean;

  CompanyDetailRoute({this.id, this.bean});

  @override
  _CompanyDetailRouteState createState() => _CompanyDetailRouteState();
}

class _CompanyDetailRouteState extends State<CompanyDetailRoute> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<CompanyDetailModel>(
        model: CompanyDetailModel(widget.id ?? widget.bean),
        onModelReady: (model) => model.queryCompanyById(),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              brightness: Brightness.dark,
              leading: CustomBackButton(),
              elevation: 1,
              centerTitle: true,
              title: Text(
                '${widget.bean?.companyName ?? '企业'}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
            body: Builder(builder: (context) {
              if (model.isBusy) {
                return ViewStateBusyWidget();
              }
              if (model.isError) {
                return ViewStateErrorWidget(
                    error: model.viewStateError, onPressed: model.queryCompanyById);
              }
              if (model.isEmpty) {
                return ViewStateEmptyWidget(onPressed: model.queryCompanyById);
              }
              return CompanyDetailBasicWidget();
            }),
          );
        });
  }
}

class CompanyDetailModel extends BaseViewStateModel {
  DemoCompanyBean companyBean;
  String _id;

  CompanyDetailModel(dynamic args) {
    if (args is String) {
      _id = args;
    } else if (args is DemoCompanyBean) {
      companyBean = args;
      _id = companyBean.id;
    }
  }

  queryCompanyById() async {
    if (companyBean != null) {
      setIdle();
      return;
    }
    setBusy();
    try {
      companyBean = await ApiDemo.queryCompanyById(_id);
      if (companyBean == null) {
        setEmpty();
      }
      setIdle();
    } catch (e, s) {
      setError(e, s);
    }
  }
}
