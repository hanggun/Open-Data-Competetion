import 'dart:math';
import 'dart:ui';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';

void showToast(
  String text, {
  Color textColor,
  ToastGravity gravity = ToastGravity.CENTER,
  Toast toastLength: Toast.LENGTH_LONG,
}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: text,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIos: 2,
    backgroundColor: Colors.grey[700],
    fontSize: 16,
    textColor: textColor ?? Colors.white,
  );
}

void showFlushBar(
  BuildContext ctx, {
  String title,
  String message,
  Duration duration = const Duration(seconds: 4),
}) {
  Flushbar(title: title, message: message, duration: duration).show(ctx);
}

void showLoading(BuildContext context, [String text = "加载中..."]) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ]),
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            constraints: BoxConstraints(minHeight: 120, minWidth: 180),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 30,
                  width: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

class StatusBarUtil {
  ///根据色彩控制状态栏字体颜色
  static setStatusBarColor(bool blackFont) {
    /// 状态栏透明
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: blackFont ? Brightness.light : Brightness.dark,
      statusBarBrightness: blackFont ? Brightness.light : Brightness.dark,
    ));
  }

  ///导航栏背景色
  static setNavigationBarColor(Color color) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
      systemNavigationBarIconBrightness:
          color.computeLuminance() == 0 ? Brightness.light : Brightness.dark,
    ));
  }
}

class FileUtil {
  static Map<String, dynamic> readFile(String path) {}
  static void saveFile(String path, String json) {}
}
