// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fake_api_client_impl.dart';

// **************************************************************************
// RestApiGenerator
// **************************************************************************

mixin _$FakeAPIClientImplMixin {
  late final Dio _dio;

  void _$setHttpClientInstance(Dio dio) => _dio = dio;

  Future<Map<String, dynamic>> getData() async {
    try {
      var response = await _dio.fetch(RequestOptions(
        method: 'GET',
        path: '/data',
        data: null,
        baseUrl: _dio.options.baseUrl,
        headers: Map.from(_dio.options.headers),
        queryParameters: Map.from(_dio.options.queryParameters),
      ));
      return response.data;
    } on DioException catch (exception) {
      return _onDioException(
        exception: exception,
        onFailedResponse: FakeAPIClientImpl._onFailedResponse,
      );
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
