import 'package:dio/dio.dart';

class ApiExceptions {
  static String getMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout";

      case DioExceptionType.sendTimeout:
        return "Send timeout";

      case DioExceptionType.receiveTimeout:
        return "Receive timeout";

      case DioExceptionType.connectionError:
        return "No Internet Connection";

      case DioExceptionType.cancel:
        return "Request Cancelled";

      case DioExceptionType.badCertificate:
        return "Bad Certificate";

      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);

      case DioExceptionType.unknown:
      default:
        return "Something went wrong";
    }
  }

  static String _handleBadResponse(Response? response) {
    switch (response?.statusCode) {
      case 400:
        return "Bad Request";

      case 401:
        return "Unauthorized";

      case 403:
        return "Forbidden";

      case 404:
        return "Not Found";

      case 409:
        return "Conflict";

      case 422:
        return "Validation Error";

      case 500:
        return "Internal Server Error";

      default:
        return response?.statusMessage ??
            "Unexpected Server Error";
    }
  }
}