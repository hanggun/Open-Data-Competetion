import 'package:business_mining/demo/home/home_route.dart';
import 'package:business_mining/net/api_demo.dart';
import 'package:business_mining/provider/provider_widget.dart';
import 'package:business_mining/provider/view_state_page_list_model.dart';
import 'package:business_mining/provider/view_state_widget.dart';
import 'package:business_mining/demo/home/item_company_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../r.dart';

class SearchCompanyModel extends ViewStatePageListModel {
  final String mode;
  SearchCompanyModel(this.mode) {
    setEmpty();
  }

  String _content;

  set content(String text) {
    if (_content == text) {
      return;
    }
    _content = text;
    setBusy();
    refresh(init: true);
  }

  @override
  Future<List> loadData({int pageNum}) async {
    if (_content?.isEmpty ?? true) {
      setEmpty();
      return null;
    }
    var list = await ApiDemo.searchCompany(content: _content, page: pageNum);
    if (_content?.isEmpty ?? true) {
      setEmpty();
      return null;
    }
    return list;
  }
}

class SearchCompanyWidget extends StatefulWidget {
  final String mode;
  SearchCompanyWidget({
    Key key,
    this.mode,
  }) : super(key: key);
  @override
  _SearchCompanyWidgetState createState() => _SearchCompanyWidgetState();
}

class _SearchCompanyWidgetState extends State<SearchCompanyWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  SearchCompanyModel _model;

  @override
  void initState() {
    _model = SearchCompanyModel(widget.mode);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var of = Provider.of<SearchModel>(context);
    if (widget.mode == of.mode) {
      _model.content = of.content;
    }
    return ProviderWidget<SearchCompanyModel>(
        model: _model,
        child: buildHistory(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return ViewStateBusyWidget();
          }
          if (model.isError) {
            return ViewStateErrorWidget(error: model.viewStateError, onPressed: model.initData);
          }
          if (model.isEmpty) {
            return child;
          }
          return SmartRefresher(
            physics: BouncingScrollPhysics(),
            controller: model.refreshController,
            onRefresh: model.refresh,
            onLoading: model.loadMore,
            enablePullUp: true,
            child: ListView.builder(
                itemCount: model.list?.length ?? 0,
                itemBuilder: (context, index) {
                  return ItemCompanyWidget(
                    item: model.list[index],
                    onClick: () =>
                        ScrollStartNotification(metrics: null, context: context).dispatch(context),
                  );
                }),
          );
        });
  }

  Widget buildHistory() {
    var title = Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '历史搜索',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFFA6ADB5),
            ),
          ),
        )),
        IconButton(
          icon: SvgPicture.asset(
            R.svgDelete,
            width: 16,
            height: 16,
          ),
          onPressed: () {
            Provider.of<SearchModel>(context, listen: false).clearHistory();
          },
        ),
      ],
    );
    return Consumer<SearchModel>(
      child: title,
      builder: (context, model, child) {
        var list = model.history
            .map<Widget>((e) => ListTile(
                  onTap: () {
                    Provider.of<SearchModel>(context, listen: false).content = e;
                  },
                  title: Text('$e', style: Theme.of(context).textTheme.bodyText1),
                  trailing: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(Icons.close, size: 14),
                    ),
                    onTap: () => model.removeHistory(e),
                  ),
                  dense: true,
                  contentPadding: const EdgeInsets.only(left: 12, right: 4),
                ))
            .toList();
        list.insert(0, title);
        return Column(children: list);
      },
    );
  }
}
