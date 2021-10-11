import 'package:business_mining/common/color.dart';
import 'package:business_mining/common/global.dart';
import 'package:business_mining/demo/home/search_company_widget.dart';
import 'package:business_mining/widget/generic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  static String modeBidding = '搜招标';
  static String modeCompany = '查企业';

  HomeRoute({
    Key key,
  }) : super(key: key);

  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class SearchModel with ChangeNotifier {
  TextEditingController textController = TextEditingController();
  String _content;
  String _mode = HomeRoute.modeCompany;

  List<String> history;

  String get content => _content;

  set content(String value) {
    textController.text = value;
  }

  String get mode => _mode;

  set mode(String value) {
    _mode = value;
    notifyListeners();
  }

  SearchModel() {
    textController.addListener(() {
      _content = textController.text;
      notifyListeners();
    });
    history = Global.getHistory();
  }

  void addHistory() {
    if (textController.text.isEmpty || history.contains(textController.text)) {
      return;
    }
    history.add(textController.text);
    if (history.length > 6) {
      history.removeAt(0);
    }
    notifyListeners();
    Global.setHistory(history);
  }

  void removeHistory(String e) {
    if (e == null || e.isEmpty) {
      return;
    }
    history.remove(e);
    notifyListeners();
    Global.setHistory(history);
  }

  void clearHistory() {
    history.clear();
    notifyListeners();
    Global.setHistory(history);
  }
}

class _HomeRouteState extends State<HomeRoute> {
  SearchModel _model = SearchModel();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: GenericWidget.appBar('查企业', leading: Offstage()),
      body: Column(
        children: [
          //状态栏
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  height: 40,
                  child: TextField(
                    focusNode: _focusNode,
                    autofocus: false,
                    controller: _model.textController,
                    cursorHeight: 18,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.only(right: 8),
                      hintText: '请输入关键字',
                      hintStyle:
                          Theme.of(context).textTheme.bodyText1.copyWith(color: TextColor.textHint),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFF5F5F7),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  _model.content = '';
                },
                minWidth: 56,
                height: 56,
                shape: CircleBorder(),
                child: Text(
                  '清除',
                  style: TextStyle(fontSize: 14, color: TextColor.textBlack),
                ),
              )
            ],
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                _focusNode.unfocus();
                _model.addHistory();
                return true;
              },
              child: ChangeNotifierProvider<SearchModel>.value(
                value: _model,
                child: SearchCompanyWidget(mode: HomeRoute.modeCompany),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
