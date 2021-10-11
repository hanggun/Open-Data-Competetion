import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'custom_back_button.dart';

///全局统一配置的widget样式
///一键生成工具类
class GenericWidget {
  GenericWidget._();

  ///生成通用的头部
  static AppBar appBar(
    String title, {
    double elevation = 1,
    List<Widget> actions,
    Function onLeadingPressed,
    Color color,
    Color leadingColor,
    Brightness brightness,
    Widget bottom,
    String actionText,
    Function onActionTap,
    Widget leading,
  }) {
    if (actions == null && actionText != null) {
      actions = [
        MaterialButton(
          onPressed: onActionTap,
          minWidth: 64,
          shape: CircleBorder(),
          child: Text(
            actionText,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        )
      ];
    }
    var isDarkBg = (color?.computeLuminance() ?? 0) < 0.5;
    return AppBar(
      backgroundColor: color,
      leading: leading ??
          CustomBackButton(
              onPressed: onLeadingPressed,
              color: leadingColor ?? (isDarkBg ? Colors.white : Colors.black)),
      centerTitle: true,
      elevation: elevation,
      brightness: brightness ?? (isDarkBg ? Brightness.dark : Brightness.light),
      actions: actions,
      title: Text(
        title,
        style: TextStyle(
            color: isDarkBg ? Colors.white : Colors.black, fontSize: 16),
      ),
      bottom: bottom,
    );
  }

  static BoxDecoration primaryGradient({double opacity = 1}) {
    return BoxDecoration(
      gradient: LinearGradient(colors: <Color>[
        Color(0xFF5BB3FE).withOpacity(opacity),
        Color(0xFF64CFFF).withOpacity(opacity),
      ]),
    );
  }

  static Widget primaryButton({
    String text,
    GestureTapCallback onTap,
    double height = 52,
    double width = double.infinity,
    double radius = 8,
    Color color,
    Color textColor,
    FontWeight fontWeight,
  }) {
    return Material(
      color: color ?? const Color(0xff4D7CFE),
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            text ?? '',
            style: TextStyle(
              fontSize: 14,
              color: textColor ?? Colors.white,
              fontWeight: fontWeight ?? FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
