// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jsonplaceholder_api_client_impl.dart';

// **************************************************************************
// RestApiGenerator
// **************************************************************************

mixin _$JsonPlaceholderAPIClientImplMixin {
  late final Dio _dio;

  void _$setHttpClientInstance(Dio dio) => _dio = dio;

  Future<List<Post>> getPosts({int? userId}) async {
    try {
      var response = await _dio.fetch(RequestOptions(
        method: 'GET',
        path: '/posts',
        data: null,
        baseUrl: _dio.options.baseUrl,
        headers: Map.from(_dio.options.headers),
        queryParameters: Map.from(_dio.options.queryParameters)
          ..addAll({'userId': userId}),
      ));
      return await JsonPlaceholderAPIClientImpl._onSuccessfulResponse(response);
    } on DioException catch (exception) {
      return _onDioException(exception: exception);
    }
  }

  FutureOr<ReturnType> _onDioException<ReturnType>({
    required DioException exception,
    FutureOr<ReturnType> Function(Response response)? onFailedResponse,
  }) async {
    if (exception.response == null) throw NetworkException();
    if (exception.error is SocketException) throw NetworkException();
    final response = exception.response!;
    if (onFailedResponse != null) return await onFailedResponse(response);
    throw ServerException(message: response.data.toString());
  }
}
