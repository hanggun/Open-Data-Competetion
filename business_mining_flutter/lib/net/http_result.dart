import 'package:flutter/widgets.dart';

class HttpResult<T> {
  bool success;
  T data;
  String message;

  HttpResult.fail({this.message}) : success = false;

  HttpResult.success({this.data}) : success = true;

  ///成功时回调
  void onSuccess(ValueChanged<T> valueChanged) {
    if (success) {
      valueChanged?.call(data);
    }
  }

  ///失败时回调
  void onFail(ValueChanged<String> valueChanged) {
    if (!success) {
      valueChanged?.call(message);
    }
  }
}
