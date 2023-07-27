import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hris/src/controller/auth_controller.dart';
import 'package:hris/src/helper/read_write.dart';
import 'package:hris/src/view/auth_pages/login.dart';

class Logging extends Interceptor {
  
  @override
  // ignore: unnecessary_overrides
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    var token = read("apiToken");
    options.headers['Authorization'] = 'Bearer $token';
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(response, ResponseInterceptorHandler handler) async {
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    debugPrint(
      'ERROR[PATH: ${err.requestOptions.path} ' 
    );
    if(err.response?.statusCode == 401) { 
      if(err.response?.data['message'] == 'Unauthenticated.' || err.response?.data['message'] == 'Unauthenticated User') {
        Get.off(() => const Login());
        Get.delete<AuthController>();
        remove('apiToken');
      }
    }
    return super.onError(err, handler);
  }
}