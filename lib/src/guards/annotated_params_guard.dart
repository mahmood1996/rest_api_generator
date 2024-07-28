import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';

import '../utils/utils.dart';

final class AnnotatedParamsGuard {
  static void validateParamsAreNonDartDefinedType<AnnotationType>(
    List<Element> elements,
  ) {
    final annotatedVariableElements =
        Utils.getElementsAnnotatedWith<AnnotationType>(elements)
            .whereType<VariableElement>();
    for (var e in annotatedVariableElements) {
      _validateElement<AnnotationType>(e);
    }
  }

  static void _validateElement<AnnotationType>(VariableElement e) {
    if (!Utils.isDartDefinedType(e.type)) return;
    throw InvalidGenerationSource(
      "$AnnotationType() only support objects that have .toJson() method!",
      element: e,
    );
  }
}
