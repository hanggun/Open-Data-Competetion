// base64库
import 'dart:convert' as convert;
import 'dart:core';

// 文件相关
import 'dart:io';

import 'dart:ui';

import 'package:flutter/widgets.dart';

class Base64Util {
  ///Base64加密
  static String encode(String data) {
    var content = convert.utf8.encode(data);
    var digest = convert.base64Encode(content);
    return digest;
  }

  ///Base64解密
  static String decode(String data) {
    List<int> bytes = convert.base64Decode(data);
    // 网上找的很多都是String.fromCharCodes，这个中文会乱码
    //String txt1 = String.fromCharCodes(bytes);
    String result = convert.utf8.decode(bytes);
    return result;
  }

  ///通过图片路径将图片转换成Base64字符串
  static Future<String> imageToText(String path) async {
    File file = new File(path);
    List<int> imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }

  ///将图片文件转换成Base64字符串
  static Future imageFileToText(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    return convert.base64Encode(imageBytes);
  }

  ///将Base64字符串的图片转换成图片
  static Image textToImage(String base64Txt) {
    var decodeTxt = convert.base64.decode(base64Txt);
    return Image.memory(
      decodeTxt,
      width: 100, fit: BoxFit.fitWidth,
      gaplessPlayback: true, //防止重绘
    );
  }
}
