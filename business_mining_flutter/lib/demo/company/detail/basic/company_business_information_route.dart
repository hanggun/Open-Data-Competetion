import 'package:business_mining/bean/demo_company_bean.dart';
import 'package:business_mining/provider/view_state_widget.dart';
import 'package:business_mining/widget/generic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompanyBusinessInformationRoute extends StatelessWidget {
  final DemoCompanyBean bean;

  CompanyBusinessInformationRoute(this.bean);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GenericWidget.appBar('工商信息'),
      body: bean == null ? ViewStateEmptyWidget(onPressed: null) : _buildContent(context, bean),
    );
  }

  Widget _buildContent(BuildContext context, DemoCompanyBean bean) {
    var contentStyle = Theme.of(context).textTheme.bodyText1;
    var titleStyle = Theme.of(context).textTheme.bodyText2;
    var padding2 = Padding(padding: EdgeInsets.only(top: 2));
    var padding12 = Padding(padding: EdgeInsets.only(top: 12));
    return Container(
      padding: EdgeInsets.only(left: 18, right: 8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20)),
            Text("统一社会信用代码", style: titleStyle),
            padding2,
            Text("${bean.unifiedSocialCreditCode ?? ''}", style: contentStyle),
            padding12,
            Text("纳税人识别号", style: titleStyle),
            padding2,
            Text("${bean.taxpayerIdentificationNumber ?? ''}", style: contentStyle),
            padding12,
            Text("组织机构代码", style: titleStyle),
            padding2,
            Text("${bean.organizationCode ?? ''}", style: contentStyle),
            padding12,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("经营状态", style: titleStyle),
                      padding2,
                      Text("${bean.businessState ?? ''}", style: contentStyle),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("营业期限", style: titleStyle),
                      padding2,
                      Text("${bean.businessPeriod ?? ''}", style: contentStyle),
                    ],
                  ),
                ),
              ],
            ),
            padding12,
            Text("公司类型", style: titleStyle),
            padding2,
            Text("${bean.companyType ?? ''}", style: contentStyle),
            padding12,
            Text("所属行业", style: titleStyle),
            padding2,
            Text("${bean.industryCategory ?? ''}", style: contentStyle),
            padding12,
            Text("登记机关", style: titleStyle),
            padding2,
            Text("${bean.registrationAuthority ?? ''}", style: contentStyle),
            padding12,
            Text("注册地址", style: titleStyle),
            padding2,
            Text("${bean.registeredAddress ?? ''}", style: contentStyle),
            padding12,
            Text("经营范围", style: titleStyle),
            padding2,
            Text("${bean.businessScope ?? ''}", style: contentStyle),
          ],
        ),
      ),
    );
  }
}
