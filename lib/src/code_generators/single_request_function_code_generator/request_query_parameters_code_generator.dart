import 'package:analyzer/dart/element/element.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';

import '../../guards/annotated_params_guard.dart';
import '../../utils/utils.dart';
import '../code_generator.dart';

final class RequestQueryParametersCodeGenerator
    implements CodeGenerator<MethodElement> {
  RequestQueryParametersCodeGenerator({
    required CodeGenerator<VariableElement> elementJsonMappingCodeGen,
  }) : _elementJsonMappingCodeGen = elementJsonMappingCodeGen;

  final CodeGenerator<VariableElement> _elementJsonMappingCodeGen;

  @override
  String generateFor(MethodElement element) {
    AnnotatedParamsGuard.validateParamsAreNonDartDefinedType<
        QueryParametersGroup>(element.declaration.children);
    return _buildRequestQueryParameters(element);
  }

  String _buildRequestQueryParameters(MethodElement element) {
    final queryParameters = _paramsAnnotatedWithQueryParametersOn(element);

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

  Map<String, dynamic> _paramsAnnotatedWithQueryParametersOn(
    MethodElement element,
  ) {
    final annotatedElements = Utils.getElementsAnnotatedWith<QueryParameter>(
      element.declaration.children,
    ).whereType<VariableElement>();

    return Map.fromEntries(annotatedElements.map(
      (e) {
        final key = Utils.getFieldOfAnnotation<QueryParameter>(e, 'key')!
            .toStringValue();
        return MapEntry('\'$key\'', _elementJsonMappingCodeGen.generateFor(e));
      },
    ));
  }
}
