import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///自定义的pageview指示器，实现了两种效果，点放大及颜色渐变
///点的形状可以根据[ShapeBorder]进行自定义，常用圆点[CircleBorder]
// ignore: must_be_immutable
class IndicatorWidget extends AnimatedWidget {
  PageController controller;
  final int count;

  ///单个点的视图大小，size-dotSize部分为空白区域
  final double size;

  ///有色点的大小
  final double dotHeight;
  final double dotWidth;
  ShapeBorder shapeBorder;
  final Color color;

  IndicatorWidget({
    this.controller,
    this.count,
    this.size = 18,
    this.dotHeight = 4,
    this.dotWidth = 9,
    this.shapeBorder,
    this.color = Colors.white,
  }) : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, _buildColorDot).toList(),
    );
  }

  ///绘制放大效果的点
  Widget _buildDot(int index) {
    ///核心逻辑
    ///计算当前index点与pageview 当前位置的变化关系
    ///_controller.page在滑动时会实时变化，带小数值
    ///当前位置1倍变大
    ///滑动一半时，左右两边的点各放大0.5倍
    double offset = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + offset * 0.3;
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      child: Container(
        height: dotHeight * zoom,
        width: dotWidth * zoom,
        decoration: ShapeDecoration(
          color: color,
          shape: shapeBorder ?? StadiumBorder(),
        ),
      ),
    );
  }

  ///绘制不同颜色的点
  Widget _buildColorDot(int index) {
    ///核心逻辑
    ///计算当前index点与pageview 当前位置的变化关系
    ///_controller.page在滑动时会实时变化，带小数值
    ///当前位置1倍变大
    ///滑动一半时，左右两边的点各放大0.5倍
    double offset = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller?.page ?? controller?.initialPage) - index).abs(),
      ),
    );

    ///当前为1，滑动时当前的值变小，滑动方向的值逐渐变大
    double opacity = offset * 0.6 + 0.4;
    return Container(
      height: size,
      width: size,
      alignment: Alignment.center,
      child: Container(
        height: dotHeight,
        width: dotWidth,
        decoration: ShapeDecoration(
          color: color.withOpacity(opacity),
          shape: shapeBorder ?? StadiumBorder(),
        ),
      ),
    );
  }
}
