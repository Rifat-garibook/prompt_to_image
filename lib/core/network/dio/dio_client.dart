import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class DioClient {

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,

      headers: {

        "apikey": ApiConstants.apiKey,

        "Authorization":
            "Bearer ${ApiConstants.apiKey}",

        "Content-Type": "application/json",

      },

      connectTimeout: const Duration(seconds: 30),

      receiveTimeout: const Duration(seconds: 30),
    ),
  );
}