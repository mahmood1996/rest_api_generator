import 'package:analyzer/dart/element/element.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';
import 'package:rest_api_generator/src/code_generators/code_generator.dart';

import '../../utils/utils.dart';

final class RequestHeadersCodeGenerator
    implements CodeGenerator<MethodElement> {
  RequestHeadersCodeGenerator({
    required CodeGenerator<VariableElement> elementJsonMappingCodeGen,
  }) : _elementJsonMappingCodeGen = elementJsonMappingCodeGen;

  final CodeGenerator<VariableElement> _elementJsonMappingCodeGen;

  @override
  String generateFor(MethodElement element) {
    return _buildRequestHeaders(element);
  }

  String _buildRequestHeaders(MethodElement element) {
    var headersFromRequest = _getHeadersFromRequestAnnotationOn(element);
    var paramsAnnotatedWithHeader = _paramsAnnotatedWithHeader(element);

    return (StringBuffer()
          ..writeAll([
            'Map.from(_dio.options.headers)',
            if (headersFromRequest.isNotEmpty) '..addAll($headersFromRequest)',
            if (paramsAnnotatedWithHeader.isNotEmpty)
              '..addAll(${_paramsAnnotatedWithHeader(element)})',
          ]))
        .toString();
  }

  Map<String, dynamic> _paramsAnnotatedWithHeader(MethodElement element) {
    return Map.fromEntries(
      Utils.getElementsAnnotatedWith<Header>(element.declaration.children)
          .whereType<VariableElement>()
          .map((e) {
        final key =
            Utils.getFieldOfAnnotation<Header>(e, 'key')!.toStringValue();
        return MapEntry('\'$key\'', _elementJsonMappingCodeGen.generateFor(e));
      }),
    );
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
}
