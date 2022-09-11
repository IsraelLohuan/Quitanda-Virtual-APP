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
        'X-Parse-Application-Id': 'ekmCuaOtlzJK9x8ilVbyWFTtHUGiYod8dgNPHtf',
        'X-Parse-REST-API-Key': '4dui5UhCGEBOKu88OYDZwY1abfqspm8ZiuIBegFL'
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