import 'package:dio/dio.dart';
import 'package:hris/src/helper/constant.dart';
import 'dio_login_interceptor.dart';

final dio = Dio(
  BaseOptions(
    baseUrl: getBaseurl(),
    headers: <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    receiveDataWhenStatusError: true,
    // connectTimeout: 100 * 1000, // 60 seconds
    // receiveTimeout: 100 * 1000),
  ),
)..interceptors.add(Logging());