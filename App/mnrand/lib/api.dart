import 'dart:convert';

import 'package:dio/dio.dart';

String apiUrl = '';
String apiToken = '';
Options? apiHttpOptions = Options();

final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));

Future<Map<String, dynamic>> api(
    String endPoint, Map<String, dynamic> body) async {
  late String? res;
  try {
    res = (await _dio.post<String>(apiUrl + endPoint,
            data: body, options: apiHttpOptions))
        .data;
    if (res == null) return {'e': 'http'};
    if (res == '') return {'e': 'empty'};
    try {
      return jsonDecode(res);
    } catch (e) {
      return {'e': 'format'};
    }
  } catch (e) {
    return {'e': 'http'};
  }
}
