import 'package:dio/dio.dart';
import 'package:weather/services/networking/endpoints.dart';
import 'package:weather/services/networking/networking.dart';

import '../app/api/api_response.dart';

class BaseApiRepo {
  Dio dio = Dio(BaseOptions(
    baseUrl: "https://generativelanguage.googleapis.com/v1beta",
  ));
}
