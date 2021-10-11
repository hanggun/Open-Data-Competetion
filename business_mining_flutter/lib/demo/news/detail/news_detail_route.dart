import 'package:business_mining/bean/news_bean.dart';
import 'package:business_mining/provider/provider_widget.dart';
import 'package:business_mining/widget/generic_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'news_detail_model.dart';

class NewsDetailRoute extends StatefulWidget {
  final NewsBean bean;

  NewsDetailRoute(this.bean);

  @override
  _NewsDetailRouteState createState() => _NewsDetailRouteState();
}

class _NewsDetailRouteState extends State<NewsDetailRoute> {
  NewsDetailModel newsDetailModel;

  @override
  void initState() {
    newsDetailModel = NewsDetailModel(widget.bean);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GenericWidget.appBar("资讯详情"),
      body: ProviderWidget<NewsDetailModel>(
          model: newsDetailModel,
          builder: (context, model, child) {
            return Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 48,
                  child: model.bean.url != null
                      ? WebView(
                          initialUrl: "${model.bean.url}",
                          //JS执行模式 是否允许JS执行
                          javascriptMode: JavascriptMode.unrestricted,
                        )
                      : CupertinoScrollbar(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: HtmlWidget(
                                _formatContent(model.bean),
                                textStyle: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            );
          }),
    );
  }

  String _formatContent(NewsBean bean) {
    if (bean.elements == null) {
      return "";
    }
    if (bean.elements.contains("<h1>") || bean.elements.contains("<h2>")) {
      return bean.elements;
    }
    var stringBuffer = StringBuffer();
    stringBuffer.writeln("<h2>${bean.title}</h2>");
    stringBuffer
        .writeln('''<p style="color:SILVER">来源：${bean.sourceTwo ?? bean.sourceOne ?? ""}</p>''');
    stringBuffer.writeln(bean.elements);
    return stringBuffer.toString();
  }
}
