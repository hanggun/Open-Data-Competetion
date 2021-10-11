import 'dart:async';

import 'package:business_mining/bean/demo_company_bean.dart';
import 'package:business_mining/net/api_demo.dart';
import 'package:business_mining/provider/view_state_model.dart';

///推荐企业列表
class RecommendCompanyListModel extends ViewStateModel {
  List<DemoCompanyBean> _list;
  int _index;
  DemoCompanyBean bean;
  Timer _timer;

  final String id;
  RecommendCompanyListModel(this.id);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Future<dynamic> customLoadData() async {
    _list = await ApiDemo.queryRecommend(id);
    if (_list != null && _list.isNotEmpty) {
      bean = _list[0];
      _index = 0;
      setIdle();
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        _index++;
        if (_index >= _list.length) {
          _index = _index % _list.length;
        }
        bean = _list[_index];
        setIdle();
      });
    }
    return _list;
  }
}
