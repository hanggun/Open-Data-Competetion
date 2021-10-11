import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'view_state_model.dart';

/// 基于
abstract class ViewStateListModel<T> extends BaseViewStateModel {
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  /// 页面数据
  List<T> list = [];

  /// 第一次进入页面loading skeleton
  initData() async {
    setBusy();
    await refresh(init: true);
  }

  // 下拉刷新
  refresh({bool init = false}) async {
    try {
      List<T> data = await loadData();
      if (data == null || data.isEmpty) {
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list.clear();
        list.addAll(data);
        setIdle();
      }
    } catch (e, s) {
      if (init) list.clear();
      setError(e, s);
    }
    _refreshController.refreshCompleted();
  }

  // 加载数据
  Future<List<T>> loadData();

  onCompleted(List<T> data) {}
}
