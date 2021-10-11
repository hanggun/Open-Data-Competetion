import 'package:business_mining/bean/demo_company_bean.dart';
import 'package:business_mining/demo/company/detail/company_detail_route.dart';
import 'package:business_mining/r.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nav_router/nav_router.dart';

///地图界面企业信息展示
class ItemCompanyWidget extends StatefulWidget {
  final DemoCompanyBean item;

  ///用户定位
  final dynamic userLocation;

  final Function onClick;

  ItemCompanyWidget({
    Key key,
    this.item,
    this.userLocation,
    this.onClick,
  }) : super(key: key);

  @override
  _ItemCompanyWidgetState createState() => _ItemCompanyWidgetState();
}

class _ItemCompanyWidgetState extends State<ItemCompanyWidget> {
  @override
  void initState() {
    _calcDistance();
    super.initState();
  }

  var distance;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Material(
          elevation: 4,
          shadowColor: Colors.grey[100],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(3)),
          child: InkWell(
            onTap: () {
              routePush(CompanyDetailRoute(bean: widget.item));
              widget.onClick?.call();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, left: 14, bottom: 8),
                        child: Text(
                          '${widget.item?.companyName ?? ''}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  child: Text(
                    '法人：${widget.item?.legalRepresentative ?? ''} | 注册时间：${widget.item?.establishDate?.replaceAll('00:00:00', '') ?? ''}',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, right: 14, top: 8),
                  child: Text(
                    '${widget.item?.industryCategory ?? ''}',
                  ),
                ),
                Divider(height: 16, color: Color(0xFFEEEEEE), thickness: 0.5),
                Padding(
                  padding: const EdgeInsets.only(left: 14, bottom: 8, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          '${widget.item?.registeredAddress ?? ''}',
                        ),
                      ),
                      Offstage(
                        offstage: widget.userLocation == null,
                        child: SvgPicture.asset(R.svgLocationCircle, width: 17, height: 17),
                      ),
                      Offstage(
                        offstage: widget.userLocation == null,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text('${distance ?? ''}km'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _calcDistance() async {
    return;
  }
}
