import 'package:flutter/material.dart';

import '../../../services/networking/http_method.dart';
import '../../../services/networking/networking.dart';
import 'api_response.dart';

class Endpoint {
  final String url;
  final HttpMethod method;
  final Map<String, dynamic> queryParams;
  final Map<String, dynamic> pathParams;
  Map<String, dynamic> bodyParams;

  Endpoint({
    required this.url,
    this.method = HttpMethod.GET,
    this.queryParams = const {},
    this.pathParams = const {},
    this.bodyParams = const {},
  });

  factory Endpoint.empty() => Endpoint(url: '');
  String getShareableLink() {
    String processedUrl = url;
    pathParams.forEach((key, value) {
      processedUrl = processedUrl.replaceAll(':$key', value.toString());
    });
    Uri uri = Uri.parse(processedUrl);
    Uri uriWithQuery = uri.replace(queryParameters: queryParams);

    return getBaseUrl() + uriWithQuery.toString();
  }

  String getBaseUrl() {
    Uri uri = Uri.base;
    return '${uri.scheme}://${uri.host}:${uri.port}/';
  }

  @override
  String toString() {
    return 'Endpoint(url: $url, method: ${method.toString()}, queryParams: $queryParams, pathParams: $pathParams, bodyParams: $bodyParams)';
  }

  Future<APIResponse> execute(BuildContext context,
      [Map<String, dynamic>? additionalData]) async {
    switch (method) {
      case HttpMethod.GET:
        return await NetworkingService().getAPICall(
          endpoint: url,
          pathParameters: additionalData?['pathParams'] ?? pathParams,
          queryParameters: additionalData?['queryParams'] ?? queryParams,
        );
      case HttpMethod.POST:
        return await NetworkingService().postAPICall(
          endpoint: url,
          pathParameters: additionalData?['pathParams'] ?? pathParams,
          queryParameters: additionalData?['queryParams'] ?? queryParams,
          data: additionalData?['bodyParams'] ?? bodyParams,
        );
      case HttpMethod.PATCH:
        return await NetworkingService().patchAPICall(
          endpoint: url,
          pathParameters: additionalData?['pathParams'] ?? pathParams,
          queryParameters: additionalData?['queryParams'] ?? queryParams,
          data: additionalData?['bodyParams'] ?? bodyParams,
        );
      case HttpMethod.PUT:
        return await NetworkingService().putAPICall(
          endpoint: url,
          pathParameters: additionalData?['pathParams'] ?? pathParams,
          queryParameters: additionalData?['queryParams'] ?? queryParams,
          data: additionalData?['bodyParams'] ?? bodyParams,
        );
      case HttpMethod.DELETE:
        return await NetworkingService().deleteAPICall(
          endpoint: url,
          pathParameters: additionalData?['pathParams'] ?? pathParams,
          queryParameters: additionalData?['queryParams'] ?? queryParams,
          data: additionalData?['bodyParams'] ?? bodyParams,
        );
      default:
        return const InvalidResponse();
    }
  }
}
