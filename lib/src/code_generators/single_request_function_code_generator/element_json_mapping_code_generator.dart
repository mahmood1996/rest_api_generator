import 'package:analyzer/dart/element/element.dart';
import 'package:rest_api_generator/src/utils/utils.dart';

import '../code_generator.dart';

final class ElementJsonMappingCodeGenerator
    implements CodeGenerator<VariableElement> {
  @override
  String generateFor(VariableElement element) {
    return switch (Utils.isDartDefinedType(element.type)) {
      true => element.displayName,
      false => '${element.displayName}.toJson()',
    };
  }
}
