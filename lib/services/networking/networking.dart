import 'dart:io';
import 'package:dio/dio.dart';
import 'package:weather/app/exceptions/app_exceptions.dart';
import 'package:weather/repository/base_api_repo.dart';

import '../../app/api/api_response.dart';

abstract class Networking {
  Future<dynamic> getAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
  });

  Future<dynamic> postAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
    dynamic data,
  });

  Future<dynamic> patchAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
    dynamic data,
  });

  Future<dynamic> putAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
    dynamic data,
  });

  Future<dynamic> deleteAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
    dynamic data,
  });
}

class NetworkingService extends BaseApiRepo implements Networking {
  final Options? options;
  NetworkingService({
    this.options,
  });

  Options _getOptions() {
    return options ??
        Options(
          headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': "*",
            // 'xx-token': token ?? '',
          },
        );
  }

  String setupPathParams(
      String endpoint, Map<String, dynamic>? pathParameters) {
    if (pathParameters != null) {
      pathParameters.forEach((key, value) {
        endpoint = endpoint.replaceAll('{$key}', value.toString());
      });
    }
    return endpoint;
  }

  @override
  Future<APIResponse> getAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
  }) async {
    // setting up path params with the endpoint
    endpoint = setupPathParams(endpoint, pathParameters);

    try {
      final response = await dio.get(
        endpoint,
        options: _getOptions(),
        queryParameters: queryParameters,
      );

      return returnResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return returnResponse(e.response!);
      }
      throw convertDioExceptionToAppException(e);
    }
  }

  @override
  Future<APIResponse> postAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
    dynamic data,
  }) async {
    try {
      // setting up path params with the endpoint
      endpoint = setupPathParams(endpoint, pathParameters);

      final response = await dio.post(
        endpoint,
        options: _getOptions(),
        queryParameters: queryParameters,
        data: data,
      );
      return returnResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return returnResponse(e.response!);
      }
      throw convertDioExceptionToAppException(e);
    }
  }

  @override
  Future<APIResponse> deleteAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
    dynamic data,
  }) async {
    try {
      // setting up path params with the endpoint
      endpoint = setupPathParams(endpoint, pathParameters);

      final response = await dio.delete(
        endpoint,
        options: _getOptions(),
        data: data,
        queryParameters: queryParameters,
      );
      return returnResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return returnResponse(e.response!);
      }
      throw convertDioExceptionToAppException(e);
    }
  }

  @override
  Future<APIResponse> patchAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
    dynamic data,
  }) async {
    try {
      // setting up path params with the endpoint
      endpoint = setupPathParams(endpoint, pathParameters);

      final response = await dio.patch(
        endpoint,
        options: _getOptions(),
        queryParameters: queryParameters,
        data: data,
      );
      return returnResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return returnResponse(e.response!);
      }
      throw convertDioExceptionToAppException(e);
    }
  }

  @override
  Future<APIResponse> putAPICall({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? pathParameters,
    dynamic data,
  }) async {
    try {
      // setting up path params with the endpoint
      endpoint = setupPathParams(endpoint, pathParameters);

      final response = await dio.put(
        endpoint,
        options: _getOptions(),
        queryParameters: queryParameters,
        data: data,
      );
      return returnResponse(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return returnResponse(e.response!);
      }
      throw convertDioExceptionToAppException(e);
    }
  }

  APIResponse returnResponse(Response response) {
    final statusCode = response.statusCode;
    final dynamic responseData = response.data;
    if (statusCode == HttpStatus.ok ||
        statusCode == HttpStatus.created ||
        statusCode == HttpStatus.accepted) {
      return SuccessResponse(
        successMessage:
            responseData?['statusMessage'] ?? 'Fetched Successfully.',
        statusCode: statusCode!.toString(),
        data: responseData?['data'],
        rawData: responseData,
      );
    } else {
      return ErrorResponse(
        errorMessage: responseData?['statusMessage'] ?? 'Something went wrong!',
        errorCode: statusCode!.toString(),
        data: responseData?['data'],
      );
    }
  }

  AppException convertDioExceptionToAppException(DioException error) {
    if (error.error is SocketException) {
      return InternetException();
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return RequestTimeoutException();
    } else {
      return FetchDataException(error.message);
    }
  }
}
