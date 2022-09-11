import 'package:dio/dio.dart';

abstract class HttpMethods {
  static const String post = 'POST';
  static const String get = 'GET';
  static const String put = 'PUT';
  static const String delete = 'DELETE';
  static const String patch = 'PATCH';
}

class HttpManager {

  Future<Map> restRequest({
    required String url,
    required String method,
    Map<String, dynamic>? headers,
    Map? body
  }) async {
    Dio dio = Dio();

    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll({
        'content-type': 'application/json',
        'accept': 'application/json',
        'X-Parse-Application-Id': 'g1Oui3JqxnY4S1ykpQWHwEKGOe0dRYCPvPF4iykc',
        'X-Parse-REST-API-Key': 'rFBKU8tk0m5ZlKES2CGieOaoYz6TgKxVMv8jRIsN',
      });

    try {
      Response response = await dio.request(
        url, 
        options: Options(
          method: method,
          headers: defaultHeaders
        ),
        data: body
      );

      return response.data;
    } on DioError catch(error) {
      return error.response!.data;
    } catch(error) {
      return {};
    }
  }
}