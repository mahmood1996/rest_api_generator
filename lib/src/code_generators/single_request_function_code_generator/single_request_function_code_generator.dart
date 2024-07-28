import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';
import 'package:source_gen/source_gen.dart';

import '../../utils/utils.dart';
import '../code_generator.dart';
import 'element_json_mapping_code_generator.dart';
import 'request_body_code_generator.dart';
import 'request_headers_code_generator.dart';
import 'request_query_parameters_code_generator.dart';

final class SingleRequestFunctionCodeGenerator
    implements CodeGenerator<MethodElement> {
  SingleRequestFunctionCodeGenerator() {
    _elementJsonMappingCodeGen = ElementJsonMappingCodeGenerator();
    _requestBodyCodeGen = RequestBodyCodeGenerator(
      elementJsonMappingCodeGen: _elementJsonMappingCodeGen,
    );
    _requestHeadersCodeGen = RequestHeadersCodeGenerator(
      elementJsonMappingCodeGen: _elementJsonMappingCodeGen,
    );
    _requestQueryParamsCodeGen = RequestQueryParametersCodeGenerator(
      elementJsonMappingCodeGen: _elementJsonMappingCodeGen,
    );
  }

  late final CodeGenerator<MethodElement> _requestBodyCodeGen;
  late final CodeGenerator<MethodElement> _requestHeadersCodeGen;
  late final CodeGenerator<MethodElement> _requestQueryParamsCodeGen;
  late final CodeGenerator<VariableElement> _elementJsonMappingCodeGen;

  @override
  String generateFor(MethodElement element) {
    return (StringBuffer()
          ..writeAll([
            _buildMethodDeclaration(element),
            _buildMethodBody(element),
          ]))
        .toString();
  }

  String _buildMethodDeclaration(MethodElement element) {
    return element.declaration.toString();
  }

  String _buildMethodBody(MethodElement element) {
    _validateMethodReturnType(element);

    bool canReturnValue = Utils.canReturnValue(element.returnType);

    return (StringBuffer()
          ..writeAll([
            'async {\n',
            'try {\n',
            '${canReturnValue ? 'var response = ' : ''}await _dio.fetch(RequestOptions(\n',
            'method: \'${_buildRequestType(element)}\',\n',
            'path: \'${_buildRequestPath(element)}\',\n',
            'data: ${_requestBodyCodeGen.generateFor(element)},\n',
            'baseUrl: ${_buildRequestBaseUrl(element)},\n',
            'headers: ${_requestHeadersCodeGen.generateFor(element)},\n',
            'queryParameters: ${_requestQueryParamsCodeGen.generateFor(element)},\n',
            '));\n',
            if (canReturnValue) '${_buildMethodReturn(element)}\n',
            '} on DioException catch(exception) {\n',
            '${_buildOnDioExceptionReturn(element)};\n',
            '}\n}\n',
          ]))
        .toString();
  }

  void _validateMethodReturnType(MethodElement element) {
    final methodReturnType = element.returnType;
    if (methodReturnType is VoidType) return;
    if (methodReturnType.isDartAsyncFuture) return;
    if (methodReturnType.isDartAsyncFutureOr) return;
    throw InvalidGenerationSource(
      "Request annotation only support methods that return [void, Future<T>, and FutureOr<T>]",
      element: element,
    );
  }

  String _buildMethodReturn(MethodElement element) {
    final onSuccessfulResponse =
        Utils.getFieldOfAnnotation<Request>(element, 'onSuccessfulResponse')
            ?.toFunctionValue();

    if (onSuccessfulResponse != null) {
      return (StringBuffer()
            ..writeAll([
              'return await ',
              '${Utils.getFunctionReferenceAsString(onSuccessfulResponse)}(response);',
            ]))
          .toString();
    }

    return switch ((element.returnType as InterfaceType)
        .typeArguments
        .where((e) => !Utils.isDartDefinedType(e))
        .firstOrNull) {
      (null) => 'return response.data;',
      (DartType type) =>
        'return ${type.element!.displayName}.fromJson(response.data);',
    };
  }

  String _buildOnDioExceptionReturn(MethodElement element) {
    final buffer = StringBuffer();

    final onFailedResponse =
        Utils.getFieldOfAnnotation<Request>(element, 'onFailedResponse')
            ?.toFunctionValue();

    buffer.writeAll([
      'return _onDioException(exception: exception',
      if (onFailedResponse != null) ...[
        ',\nonFailedResponse: ${Utils.getFunctionReferenceAsString(onFailedResponse)},\n',
      ],
      ')',
    ]);

    return buffer.toString();
  }

  String _buildRequestBaseUrl(MethodElement element) {
    String? baseUrl = Utils.getFieldOfAnnotation<Request>(element, 'baseUrl')
        ?.toStringValue();
    return switch (baseUrl) {
      (null) => '_dio.options.baseUrl',
      (String baseUrl) => '\'$baseUrl\''
    };
  }

  String _buildRequestType(MethodElement element) {
    final requestAnnotation = Utils.getFirstAnnotationOf<Request>(element)!;

    return requestAnnotation.getField('method')?.toStringValue() ?? '';
  }

  String _buildRequestPath(MethodElement element) {
    String requestPath =
        Utils.getFieldOfAnnotation<Request>(element, 'path')?.toStringValue() ??
            '';

    var pathParameters =
        Utils.getElementsAnnotatedWith<Path>(element.declaration.children);

    for (var param in pathParameters) {
      requestPath = requestPath.replaceAll(
          '{${param.displayName}}', '\$${param.displayName}');
    }

    return requestPath;
  }
}
