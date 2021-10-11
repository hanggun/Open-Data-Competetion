import 'dart:convert';

import 'package:business_mining/common/global.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';

final Http https = Http(isHttps: true);

class Http extends DioForNative {
  static const String HTTPS_URL = "http://contest.fnbid.com";

  Http({bool isHttps = false}) {
    /// 初始化 加入app通用处理
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    init(isHttps);
  }

  void init(bool isHttps) {
    interceptors..add(ApiInterceptor())..add(LogInterceptor());
    options
      ..headers = {'Authorization': isHttps ? Global.session : ''}
      ..contentType = Headers.formUrlEncodedContentType
      ..baseUrl = HTTPS_URL
      ..sendTimeout = 20000
      ..receiveTimeout = 20000
      ..sendTimeout = 20000;
  }

  void resetHeaders({session}) {
    options.headers = {'Authorization': session ?? Global.session};
  }
}

class ApiInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) async {
    logger.d('--api-request-->url-->${DateTime.now()}--> ${options.baseUrl}${options.path}' +
        ' ->data:${(options.data as FormData)?.fields?.map<String>((e) => "${e.key}:${e.value}")?.toList()}');
    return options;
  }

  @override
  onResponse(Response response) {
    logger.d(
        '--api-response-->resp-->${DateTime.now()}-->${response.request.baseUrl}${response.request.path} -->${response.data}');
    if (response.request.path.contains('static/soft/') ||
        response.request.path.startsWith('http://api.map.baidu.com/')) {
      //直接返回数据，不做预处理
      return https.resolve(response);
    }
    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.success) {
      response.data = respData.data;
      return https.resolve(response);
    } else {
      throw NotSuccessException.fromRespData(respData);
    }
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 200 == code;

  ResponseData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = json['data'];
  }
}

/// 子类需要重写
abstract class BaseResponseData {
  int code = 0;
  String message;
  dynamic data;

  bool get success;

  BaseResponseData({this.code, this.message, this.data});

  @override
  String toString() {
    return 'BaseRespData{code: $code, message: $message, data: $data}';
  }
}

/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  String message;

  NotSuccessException.fromRespData(BaseResponseData respData) {
    message = respData.message;
  }

  @override
  String toString() {
    return 'NotExpectedException{respData: $message}';
  }
}

/// 用于未登录等权限不够,需要跳转授权页面
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

String parseHttpError(dynamic e) {
  if (e is DioError) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT ||
        e.type == DioErrorType.SEND_TIMEOUT ||
        e.type == DioErrorType.RECEIVE_TIMEOUT ||
        e.type == DioErrorType.RESPONSE ||
        e.type == DioErrorType.CANCEL) {
      // timeout
      try {
        var response = (e as DioError).response;
        return response.data['message'];
      } catch (e) {
        return e.toString();
      }
    } else {
      // dio将原error重新套了一层
      e = e.error;
      return e.message;
    }
  }
  return e.toString();
}
