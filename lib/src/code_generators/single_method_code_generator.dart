import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';
import 'package:rest_api_generator/src/utils.dart';
import 'package:source_gen/source_gen.dart';

import 'code_generator.dart';

final class SingleMethodCodeGenerator implements CodeGenerator<MethodElement> {
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
            'method: \'${_buildRequestMethod(element)}\',\n',
            'path: \'${_buildRequestPath(element)}\',\n',
            'data: ${_buildRequestBody(element)},\n',
            'baseUrl: ${_buildRequestBaseUrl(element)},\n',
            'headers: ${_buildRequestHeaders(element)},\n',
            'queryParameters: ${_buildRequestQueryParameters(element)},\n',
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

  String _buildRequestMethod(MethodElement element) {
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

  String _buildRequestBody(MethodElement element) {
    _validateParamsAnnotatedWith<Body>(element);

    final paramsAnnotatedWithField =
        _createJsonModelFor<Field>(element.declaration);

    final paramsAnnotatedWithBody =
        Utils.getElementsAnnotatedWith<Body>(element.declaration.children);

    if (paramsAnnotatedWithBody.isEmpty && paramsAnnotatedWithField.isEmpty) {
      return 'null';
    }

    return (StringBuffer()
          ..writeAll([
            'Map.from($paramsAnnotatedWithField)',
            ...paramsAnnotatedWithBody
                .map((e) => '..addAll(${e.displayName}.toJson())'),
          ]))
        .toString();
  }

  String _buildRequestHeaders(MethodElement element) {
    var headersFromRequest = _getHeadersFromRequestAnnotationOn(element);
    var paramsAnnotatedWithHeader =
        _createJsonModelFor<Header>(element.declaration);

    return (StringBuffer()
          ..writeAll([
            'Map.from(_dio.options.headers)',
            if (headersFromRequest.isNotEmpty) '..addAll($headersFromRequest)',
            if (paramsAnnotatedWithHeader.isNotEmpty)
              '..addAll(${_createJsonModelFor<Header>(element.declaration)})',
          ]))
        .toString();
  }

  Map<String, dynamic> _getHeadersFromRequestAnnotationOn(
    MethodElement element,
  ) {
    return {
      for (var e in Utils.getFieldOfAnnotation<Request>(element, 'headers')!
          .toMapValue()!
          .entries)
        Utils.getLiteralValueFrom(e.key): Utils.getLiteralValueFrom(e.value),
    };
  }

  String _buildRequestQueryParameters(MethodElement element) {
    _validateParamsAnnotatedWith<QueryParametersGroup>(element);
    final queryParameters =
        _createJsonModelFor<QueryParameter>(element.declaration);

    final codeBuffer = StringBuffer();
    codeBuffer.writeAll([
      'Map.from(_dio.options.queryParameters)',
      if (queryParameters.isNotEmpty) '..addAll($queryParameters)',
      ...Utils.getElementsAnnotatedWith<QueryParametersGroup>(
        element.declaration.children,
      )
          .whereType<VariableElement>()
          .map((e) => '..addAll(${e.displayName}.toJson())'),
    ]);
    return codeBuffer.toString();
  }

  void _validateParamsAnnotatedWith<AnnotationType>(MethodElement element) {
    if (Utils.getElementsAnnotatedWith<AnnotationType>(
            element.declaration.children)
        .whereType<VariableElement>()
        .map((e) => e.type)
        .any(Utils.isDartDefinedType)) {
      throw InvalidGenerationSource(
        "$AnnotationType() only support objects that have .toJson() method!",
        element: element,
      );
    }
  }

  Map<String, String> _createJsonModelFor<AnnotationType>(Element element,
      [String annotationKeyName = 'key']) {
    return Map.fromEntries(
      Utils.getElementsAnnotatedWith<AnnotationType>(element.children)
          .whereType<VariableElement>()
          .map(
        (e) {
          final entryKey =
              Utils.getFieldOfAnnotation<AnnotationType>(e, annotationKeyName)!
                  .toStringValue()!;
          return MapEntry(
            '\'$entryKey\'',
            switch (Utils.isDartDefinedType(e.type)) {
              (true) => e.displayName,
              (false) => '${e.displayName}.toJson()'
            },
          );
        },
      ),
    );
  }
}
