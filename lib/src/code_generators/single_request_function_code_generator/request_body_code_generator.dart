import 'package:analyzer/dart/element/element.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';

import '../../guards/annotated_params_guard.dart';
import '../../utils/utils.dart';
import '../code_generator.dart';

final class RequestBodyCodeGenerator implements CodeGenerator<MethodElement> {
  final CodeGenerator<VariableElement> _elementJsonMappingCodeGen;

  RequestBodyCodeGenerator({
    required CodeGenerator<VariableElement> elementJsonMappingCodeGen,
  }) : _elementJsonMappingCodeGen = elementJsonMappingCodeGen;

  @override
  String generateFor(MethodElement element) {
    AnnotatedParamsGuard.validateParamsAreNonDartDefinedType<Body>(
      element.declaration.children,
    );
    return _buildRequestBody(element);
  }

  String _buildRequestBody(MethodElement element) {
    final paramsAnnotatedWithField = _paramsAnnotatedWithFieldOn(element);
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

  Map<String, dynamic> _paramsAnnotatedWithFieldOn(MethodElement element) {
    final result = <String, dynamic>{};

    final annotatedElements =
        Utils.getElementsAnnotatedWith<Field>(element.declaration.children)
            .whereType<VariableElement>();

    for (final e in annotatedElements) {
      final key = Utils.getFieldOfAnnotation<Field>(e, 'key')!.toStringValue();
      result['\'$key\''] = switch (
          Utils.getFieldOfAnnotation<Field>(e, 'encode')?.toFunctionValue()) {
        null => _elementJsonMappingCodeGen.generateFor(e),
        ExecutableElement fun =>
          '${Utils.getFunctionReferenceAsString(fun)}(${e.displayName})'
      };
    }

    return result;
  }
}
