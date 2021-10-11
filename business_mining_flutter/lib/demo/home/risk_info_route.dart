import 'package:business_mining/bean/demo_risk_bean.dart';
import 'package:business_mining/common/color.dart';
import 'package:business_mining/net/api_demo.dart';
import 'package:business_mining/widget/generic_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../r.dart';

class RiskInfoRoute extends StatefulWidget {
  final String id;

  RiskInfoRoute({
    Key key,
    this.id,
  }) : super(key: key);

  @override
  _RiskInfoRouteState createState() => _RiskInfoRouteState();
}

class _RiskInfoRouteState extends State<RiskInfoRoute> {
  final riskColors = [
    const Color(0xFF00A3FF),
    const Color.fromRGBO(5, 222, 14, 1),
    const Color.fromRGBO(255, 199, 0, 1),
    const Color.fromRGBO(255, 54, 54, 1),
    const Color.fromRGBO(146, 3, 3, 1),
  ];

  final riskLabel = [
    '极低',
    '较低',
    '中等',
    '较高',
    '极高',
  ];

  var cardDivider = Container(
    width: 1,
    height: 32,
    color: Colors.white,
    margin: const EdgeInsets.symmetric(horizontal: 4),
  );

  DemoRiskBean _riskBean;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var divider = Divider(
      height: 1,
      thickness: 1,
      indent: 12,
      endIndent: 12,
      color: const Color(0xFFEEEEEE),
    );

    return Scaffold(
      appBar: GenericWidget.appBar('风险信息'),
      body: DefaultTextStyle(
        style: TextStyle(fontSize: 14, color: Colors.black),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  '评估结果',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              divider,
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 8, bottom: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      '${_formatScore(_riskBean?.sumScore)}',
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: const EdgeInsets.only(right: 10)),
                    Text(
                      '综合风险',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_getLabelByScore(_riskBean?.sumScore)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getColorByScore(_riskBean?.sumScore),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12, bottom: 2),
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: riskColors
                      .map((e) => Container(
                            width: 15,
                            height: 15,
                            child: Offstage(
                              offstage: e != _getColorByScore(_riskBean?.sumScore),
                              child:
                                  SvgPicture.asset(R.svgPolygon, width: 15, height: 15, color: e),
                            ),
                          ))
                      .toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12),
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLabelText("0~1"),
                    _buildLabelText("1~2"),
                    _buildLabelText("2~3"),
                    _buildLabelText("3~4"),
                    _buildLabelText("4~5"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 4, top: 1),
                child: Row(
                  children: riskColors
                      .map((e) => Container(
                            width: 50,
                            height: 10,
                            color: e,
                          ))
                      .toList(),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12, bottom: 20),
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: riskLabel.map((e) => _buildLabelText(e)).toList(),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: const Color(0xFFEEEEEE),
              ),
              Padding(padding: const EdgeInsets.only(top: 12)),
              _buildEvaluateCard(),
              Padding(padding: const EdgeInsets.only(top: 6)),
              _buildSuggestCard(),
              Padding(padding: const EdgeInsets.only(top: 12)),
              Divider(
                height: 4,
                thickness: 4,
                color: const Color(0xFFEEEEEE),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 12),
                child: Text(
                  '经营风险总系数评估',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              _buildBusinessRisk(),
              SizedBox(height: 12),
              divider,
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 12),
                child: Text(
                  '信用风险总系数评估',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              _buildCreditRisk(),
              SizedBox(height: 12),
              divider,
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 12),
                child: Text(
                  '舆情风险总系数评估',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              _buildPublicOpinionRisk(),
              SizedBox(height: 12),
              divider,
            ],
          ),
        ),
      ),
    );
  }

  Text _buildLabelText(String str) {
    return Text(
      str,
      style: TextStyle(
        color: Color(0xff616161),
        fontSize: 12,
      ),
    );
  }

  Container _buildEvaluateCard() {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(left: 12, right: 12),
      padding: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFFF1F7FF),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 60,
            child: Text(
              '综合\n评价',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: 1,
            height: 56,
            color: Colors.white,
            margin: const EdgeInsets.only(right: 8),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: TextStyle(fontSize: 12),
                children: [
                  TextSpan(
                    text: '企业经营风险',
                  ),
                  _buildTotalString(0),
                  TextSpan(
                    text: '，信用风险',
                  ),
                  _buildTotalString(1),
                  TextSpan(
                    text: '，舆情风险',
                  ),
                  _buildTotalString(2),
                  TextSpan(
                    text: '，相关风险',
                  ),
                  _buildTotalString(3),
                  TextSpan(
                    text: '，整体风险',
                  ),
                  _buildTotalString(4),
                  TextSpan(
                    text: '。',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildSuggestCard() {
    return Container(
      height: 56,
      margin: const EdgeInsets.only(left: 12, right: 12),
      padding: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFFF1F7FF),
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: 60,
            child: Text(
              '合作\n建议',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            width: 1,
            height: 56,
            color: Colors.white,
            margin: const EdgeInsets.only(right: 8),
          ),
          Expanded(
            child: Text(
              '${_riskBean?.suggestion ?? ''}',
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  DefaultTextStyle _buildBusinessRisk() {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 12, color: TextColor.black),
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: const Color(0xFFF1F7FF),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${_formatScore(_riskBean?.operatingRiskScore)}",
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(padding: const EdgeInsets.only(left: 4)),
                Text(
                  '经营风险',
                ),
                Text(
                  '${_getLabelByScore(_riskBean?.operatingRiskScore)}',
                  style: TextStyle(color: _getColorByScore(_riskBean?.operatingRiskScore)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 72,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 4,
                        child: SvgPicture.asset(
                          R.svgPunish,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Positioned(
                        top: 26,
                        child: Text(
                          "行政处罚",
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 2,
                        child: Text(
                          "${_riskBean?.administrativeSanctionCount ?? '0'}",
                          style: TextStyle(
                            color: Color(0xff00a3ff),
                            fontSize: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                cardDivider,
              ],
            )
          ],
        ),
      ),
    );
  }

  DefaultTextStyle _buildCreditRisk() {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 12, color: TextColor.black),
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: const Color(0xFFF1F7FF),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${_formatScore(_riskBean?.creditRiskScore)}",
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(padding: const EdgeInsets.only(left: 4)),
                Text('信用风险'),
                Text(
                  '${_getLabelByScore(_riskBean?.creditRiskScore)}',
                  style: TextStyle(color: _getColorByScore(_riskBean?.creditRiskScore)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 72,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 6,
                        child: SvgPicture.asset(
                          R.svgShield,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Positioned(
                        top: 26,
                        child: Text(
                          "纳税信用\n等级",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 2,
                        child: Text(
                          "${_riskBean?.aTaxRank ?? 'A'}",
                          style: TextStyle(
                            color: Color(0xff00a3ff),
                            fontSize: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                cardDivider,
                Container(
                  width: 72,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 6,
                        child: SvgPicture.asset(
                          R.svgBag,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Positioned(
                        top: 26,
                        child: Text(
                          "欠税信息",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 2,
                        child: Text(
                          "${_riskBean?.owingTaxCount ?? '0'}",
                          style: TextStyle(
                            color: Color(0xff00a3ff),
                            fontSize: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                cardDivider,
                Container(
                  width: 72,
                  height: 64,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 4,
                        child: SvgPicture.asset(
                          R.svgShieldSearch,
                          width: 22,
                          height: 22,
                        ),
                      ),
                      Positioned(
                        top: 26,
                        child: Text(
                          "税务稽查\n状况",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 2,
                        child: Text(
                          "${_riskBean?.taxAudit ?? '0'}",
                          style: TextStyle(
                            color: Color(0xff00a3ff),
                            fontSize: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                cardDivider,
              ],
            )
          ],
        ),
      ),
    );
  }

  DefaultTextStyle _buildPublicOpinionRisk() {
    return DefaultTextStyle(
      style: TextStyle(fontSize: 12, color: TextColor.black),
      child: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, top: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: const Color(0xFFF1F7FF),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${_formatScore(_riskBean?.publicOpinionRiskScore)}",
                  style: TextStyle(
                    color: Color(0xff333333),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Padding(padding: const EdgeInsets.only(left: 4)),
                Text('舆情风险'),
                Text(
                  '${_getLabelByScore(_riskBean?.publicOpinionRiskScore)}',
                  style: TextStyle(color: _getColorByScore(_riskBean?.publicOpinionRiskScore)),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 72,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 6,
                        child: SvgPicture.asset(
                          R.svgWarning,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Positioned(
                        top: 26,
                        child: Text(
                          "正面舆情",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 2,
                        child: Text(
                          "${_riskBean?.posCount ?? '0'}",
                          style: TextStyle(
                            color: Color(0xff00a3ff),
                            fontSize: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                cardDivider,
                Container(
                  width: 72,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 6,
                        child: SvgPicture.asset(
                          R.svgBag,
                          width: 18,
                          height: 18,
                        ),
                      ),
                      Positioned(
                        top: 26,
                        child: Text(
                          "中性舆情",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 2,
                        child: Text(
                          "${_riskBean?.neuCount ?? '0'}",
                          style: TextStyle(
                            color: Color(0xff00a3ff),
                            fontSize: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                cardDivider,
                Container(
                  width: 72,
                  height: 48,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 6,
                        child: SvgPicture.asset(
                          R.svgRelationNews,
                          width: 22,
                          height: 22,
                        ),
                      ),
                      Positioned(
                        top: 26,
                        child: Text(
                          "负面舆情",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        top: 2,
                        child: Text(
                          "${_riskBean?.negCount ?? '0'}",
                          style: TextStyle(
                            color: Color(0xff00a3ff),
                            fontSize: 10,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                cardDivider,
              ],
            )
          ],
        ),
      ),
    );
  }

  void _init() async {
    var demoRiskBean = await ApiDemo.queryRiskDetail(widget.id);
    setState(() {
      _riskBean = demoRiskBean;
    });
  }

  String _getLabelByScore(num score) {
    if (score == null || score == 0) {
      return riskLabel[0];
    }
    return riskLabel[score.ceil() - 1];
  }

  Color _getColorByScore(num score) {
    if (score == null || score == 0) {
      return riskColors[0];
    }
    return riskColors[score.ceil() - 1];
  }

  TextSpan _buildTotalString(int index) {
    var element = _riskBean?.evaluate?.elementAt(index) ?? riskLabel[0];
    var indexOf = riskLabel.indexOf(element);
    if (indexOf == -1) {
      indexOf = 0;
    }
    return TextSpan(
      text: '$element',
      style: TextStyle(
        color: riskColors[indexOf],
      ),
    );
  }

  String _formatScore(num score) {
    if (score == null || score == 0) {
      return '0';
    } else {
      return score.toStringAsFixed(1);
    }
  }
}
