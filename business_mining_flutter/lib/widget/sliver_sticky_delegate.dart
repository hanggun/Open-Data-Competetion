import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///置顶头部切片
///参考：https://juejin.im/post/5d3e5b65e51d45775f516b6e
class SliverStickyDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SliverStickyDelegate({this.height, this.child});

  ///build：构建渲染的内容
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: child,
    );
  }

  ///maxExtent：展开状态下组件的高度；
  @override
  double get maxExtent => this.height;

  ///minExtent：收起状态下组件的高度；
  @override
  double get minExtent => this.height;

  ///shouldRebuild：类似于react中的shouldComponentUpdate；
  @override
  bool shouldRebuild(covariant SliverStickyDelegate oldDelegate) {
    return this.child != oldDelegate.child || this.height != oldDelegate.height;
  }
}

class SliverSafeAreaDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SliverSafeAreaDelegate({this.height, this.child});

  ///build：构建渲染的内容
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: child,
    );
  }

  ///maxExtent：展开状态下组件的高度；
  @override
  double get maxExtent => this.height;

  ///minExtent：收起状态下组件的高度；
  @override
  double get minExtent => this.height;

  ///shouldRebuild：类似于react中的shouldComponentUpdate；
  @override
  bool shouldRebuild(SliverSafeAreaDelegate oldDelegate) {
    return this.child != oldDelegate.child || this.height != oldDelegate.height;
  }
}
