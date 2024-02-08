import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';
import 'package:source_gen_test/annotations.dart';

@ShouldThrow('The source annotation should be set!')
class AClassThatNotAnnotated {}

@ShouldThrow("'RestApi' only support classes")
@RestApi()
void aFunctionAnnotatedWithRestApi() {}

@ShouldThrow("'RestApi' only support classes")
@RestApi()
const aVariableAnnotatedWithRestApi = 0;

final class Product {
  const Product();

  factory Product.fromJson(Map<String, dynamic> json) => Product();

  Map<String, dynamic> toJson() => {};
}

FutureOr<dynamic> _onSuccessfulResponse(Response response) {
  return Product.fromJson(response.data);
}

FutureOr<void> _onFailedResponse(Response response) {
  throw Exception();
}

@ShouldGenerate(
  'mixin _\$GenerateMixinWithImplMixin {\n'
  '  late final Dio _dio;\n'
  '\n'
  '  void _\$setHttpClientInstance(Dio dio) => _dio = dio;\n'
  '\n'
  '  Future<void> testPathParam(int id) async {\n'
  '    try {\n'
  '      await _dio.fetch(RequestOptions(\n'
  '        method: \'POST\',\n'
  '        path: \'/\$id\',\n'
  '        data: null,\n'
  '        baseUrl: _dio.options.baseUrl,\n'
  '        headers: Map.from(_dio.options.headers),\n'
  '        queryParameters: Map.from(_dio.options.queryParameters),\n'
  '      ));\n'
  '    } on DioException catch (exception) {\n'
  '      return _onDioException(exception: exception);\n'
  '    }\n'
  '  }\n'
  '\n'
  '  Future<dynamic> testReturnFutureOfDynamic() async {\n'
  '    try {\n'
  '      var response = await _dio.fetch(RequestOptions(\n'
  '        method: \'GET\',\n'
  '        path: \'/data\',\n'
  '        data: null,\n'
  '        baseUrl: _dio.options.baseUrl,\n'
  '        headers: Map.from(_dio.options.headers),\n'
  '        queryParameters: Map.from(_dio.options.queryParameters),\n'
  '      ));\n'
  '      return response.data;\n'
  '    } on DioException catch (exception) {\n'
  '      return _onDioException(exception: exception);\n'
  '    }\n'
  '  }\n'
  '\n'
  '  FutureOr<void> testReturnFutureOr() async {\n'
  '    try {\n'
  '      await _dio.fetch(RequestOptions(\n'
  '        method: \'POST\',\n'
  '        path: \'/do\',\n'
  '        data: null,\n'
  '        baseUrl: _dio.options.baseUrl,\n'
  '        headers: Map.from(_dio.options.headers),\n'
  '        queryParameters: Map.from(_dio.options.queryParameters),\n'
  '      ));\n'
  '    } on DioException catch (exception) {\n'
  '      return _onDioException(exception: exception);\n'
  '    }\n'
  '  }\n'
  '\n'
  '  Future<Product> testReturnFutureOfModel() async {\n'
  '    try {\n'
  '      var response = await _dio.fetch(RequestOptions(\n'
  '        method: \'GET\',\n'
  '        path: \'/product\',\n'
  '        data: null,\n'
  '        baseUrl: \'https://example.com/api\',\n'
  '        headers: Map.from(_dio.options.headers),\n'
  '        queryParameters: Map.from(_dio.options.queryParameters),\n'
  '      ));\n'
  '      return Product.fromJson(response.data);\n'
  '    } on DioException catch (exception) {\n'
  '      return _onDioException(exception: exception);\n'
  '    }\n'
  '  }\n'
  '\n'
  '  Future<void> testQueryParameters(String k, Product p1, Product p2) async {\n'
  '    try {\n'
  '      await _dio.fetch(RequestOptions(\n'
  '        method: \'POST\',\n'
  '        path: \'/api\',\n'
  '        data: null,\n'
  '        baseUrl: _dio.options.baseUrl,\n'
  '        headers: Map.from(_dio.options.headers),\n'
  '        queryParameters: Map.from(_dio.options.queryParameters)\n'
  '          ..addAll({\'key\': k, \'p1\': p1.toJson()})\n'
  '          ..addAll(p2.toJson()),\n'
  '      ));\n'
  '    } on DioException catch (exception) {\n'
  '      return _onDioException(exception: exception);\n'
  '    }\n'
  '  }\n'
  '\n'
  '  Future<void> testBodyAndFields(int id, Product p1, Product p2) async {\n'
  '    try {\n'
  '      await _dio.fetch(RequestOptions(\n'
  '        method: \'POST\',\n'
  '        path: \'/api\',\n'
  '        data: Map.from({\'key\': id, \'key2\': p1.toJson()})..addAll(p2.toJson()),\n'
  '        baseUrl: _dio.options.baseUrl,\n'
  '        headers: Map.from(_dio.options.headers),\n'
  '        queryParameters: Map.from(_dio.options.queryParameters),\n'
  '      ));\n'
  '    } on DioException catch (exception) {\n'
  '      return _onDioException(exception: exception);\n'
  '    }\n'
  '  }\n'
  '\n'
  '  Future<dynamic> testOnSuccessfulResponse() async {\n'
  '    try {\n'
  '      var response = await _dio.fetch(RequestOptions(\n'
  '        method: \'GET\',\n'
  '        path: \'/data\',\n'
  '        data: null,\n'
  '        baseUrl: _dio.options.baseUrl,\n'
  '        headers: Map.from(_dio.options.headers),\n'
  '        queryParameters: Map.from(_dio.options.queryParameters),\n'
  '      ));\n'
  '      return await _onSuccessfulResponse(response);\n'
  '    } on DioException catch (exception) {\n'
  '      return _onDioException(exception: exception);\n'
  '    }\n'
  '  }\n'
  '\n'
  '  Future<void> testHeader(String contentType, Product p) async {\n'
  '    try {\n'
  '      await _dio.fetch(RequestOptions(\n'
  '        method: \'POST\',\n'
  '        path: \'/api\',\n'
  '        data: null,\n'
  '        baseUrl: _dio.options.baseUrl,\n'
  '        headers: Map.from(_dio.options.headers)\n'
  '          ..addAll({\n'
  '            \'a\': \'b\',\n'
  '            \'c\': 2.5,\n'
  '            \'d\': [1, 2, \'ss\'],\n'
  '            \'e\': {1, \'mm\'},\n'
  '            \'f\': {\'b\': \'s\', \'c\': null}\n'
  '          })\n'
  '          ..addAll({\'Content-Type\': contentType, \'Product\': p.toJson()}),\n'
  '        queryParameters: Map.from(_dio.options.queryParameters),\n'
  '      ));\n'
  '    } on DioException catch (exception) {\n'
  '      return _onDioException(exception: exception);\n'
  '    }\n'
  '  }\n'
  '\n'
  '  Future<void> testOnFailedResponse() async {\n'
  '    try {\n'
  '      await _dio.fetch(RequestOptions(\n'
  '        method: \'POST\',\n'
  '        path: \'/api\',\n'
  '        data: null,\n'
  '        baseUrl: _dio.options.baseUrl,\n'
  '        headers: Map.from(_dio.options.headers),\n'
  '        queryParameters: Map.from(_dio.options.queryParameters),\n'
  '      ));\n'
  '    } on DioException catch (exception) {\n'
  '      return _onDioException(\n'
  '        exception: exception,\n'
  '        onFailedResponse: _onFailedResponse,\n'
  '      );\n'
  '    }\n'
  '  }\n'
  '\n'
  '  FutureOr<ReturnType> _onDioException<ReturnType>({\n'
  '    required DioException exception,\n'
  '    FutureOr<ReturnType> Function(Response response)? onFailedResponse,\n'
  '  }) async {\n'
  '    if (exception.response == null) throw NetworkException();\n'
  '    if (exception.error is SocketException) throw NetworkException();\n'
  '    final response = exception.response!;\n'
  '    if (onFailedResponse != null) return await onFailedResponse(response);\n'
  '    throw ServerException(message: response.data.toString());\n'
  '  }\n'
  '}\n',
  contains: true,
)
@RestApi()
abstract class GenerateMixinWithImpl {
  Future<int> aFunctionNotAnnotated();

  @Request(
    method: 'POST',
    path: '/{id}',
  )
  Future<void> testPathParam(@Path() int id);

  @Request(
    method: 'GET',
    path: '/data',
  )
  Future testReturnFutureOfDynamic();

  @Request(
    method: 'POST',
    path: '/do',
  )
  FutureOr<void> testReturnFutureOr();

  @Request(
    method: 'GET',
    path: '/product',
    baseUrl: 'https://example.com/api',
  )
  Future<Product> testReturnFutureOfModel();

  @Request(
    method: 'POST',
    path: '/api',
  )
  Future<void> testQueryParameters(
    @QueryParameter('key') String k,
    @QueryParameter('p1') Product p1,
    @QueryParametersGroup() Product p2,
  );

  @Request(
    method: 'POST',
    path: '/api',
  )
  Future<void> testBodyAndFields(
    @Field('key') int id,
    @Field('key2') Product p1,
    @Body() Product p2,
  );

  @Request(
    method: 'GET',
    path: '/data',
    onSuccessfulResponse: _onSuccessfulResponse,
  )
  Future testOnSuccessfulResponse();

  @Request(
    method: 'POST',
    path: '/api',
    headers: {
      'a': 'b',
      'c': 2.5,
      'd': [1, 2, 'ss'],
      'e': {1, 'mm'},
      'f': {'b': 's', 'c': null}
    },
  )
  Future<void> testHeader(
    @Header('Content-Type') String contentType,
    @Header('Product') Product p,
  );

  @Request(
    method: 'POST',
    path: '/api',
    onFailedResponse: _onFailedResponse,
  )
  Future<void> testOnFailedResponse();
}

@ShouldThrow(
  "Request annotation only support methods that return [void, Future<T>, and FutureOr<T>]",
)
@RestApi()
abstract class AFunctionReturnsNonSupportedReturnType {
  @Request(
    method: 'GET',
    path: '/product',
  )
  Product getProduct();
}

@ShouldThrow(
  "QueryParametersGroup() only support objects that have .toJson() method!",
)
@RestApi()
abstract class APrimitiveTypeAnnotatedWithQueryParametersGroup {
  @Request(
    method: 'POST',
    path: '/api',
  )
  Future<void> aPrimitiveTypeAnnotatedWithQueryParametersGroup(
      @QueryParametersGroup() int i);
}

@ShouldThrow(
  "Body() only support objects that have .toJson() method!",
)
@RestApi()
abstract class APrimitiveTypeAnnotatedWithBody {
  @Request(
    method: 'POST',
    path: '/api',
  )
  Future<void> aPrimitiveTypeAnnotatedWithBody(@Body() int i);
}
