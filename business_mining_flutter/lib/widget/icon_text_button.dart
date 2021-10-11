import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class IconTextButton extends StatelessWidget {
  final String svgPath;
  final Function onTap;
  final String text;
  final TextStyle textStyle;
  final double iconSize;
  final double iconMargin;
  final double iconPadding;
  final Color iconColor;

  const IconTextButton(
      {Key key,
      @required this.svgPath,
      this.onTap,
      @required this.text,
      this.textStyle,
      this.iconSize = 22,
      this.iconColor,
      this.iconMargin = 2,
      this.iconPadding = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        shape: CircleBorder(),
        onPressed: onTap,
        child: Tab(
          child: Text(
            text ?? '',
            style: textStyle ?? TextStyle(fontSize: 12, color: Colors.white),
          ),
          icon: Padding(
            padding: EdgeInsets.all(iconPadding),
            child: SvgPicture.asset(
              svgPath,
              height: iconSize - iconPadding,
              width: iconSize - iconPadding,
              color: iconColor,
            ),
          ),
          iconMargin: EdgeInsets.only(bottom: iconMargin),
        ),
      ),
    );
  }
}
