import 'package:analyzer/dart/element/element.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';
import 'package:source_gen/source_gen.dart';

final class AnnotatedClassesGuard {
  static void validateClassMustBeAnnotated(
    Element element,
    ConstantReader annotation,
  ) {
    if (annotation.isNull) {
      throw InvalidGenerationSource(
        'The source annotation should be set!',
        element: element,
      );
    }
  }

  static void validateAnnotatedElementIsClass(Element element) {
    if (element is ClassElement) return;
    throw InvalidGenerationSource(
      "'$RestApi' only support classes",
      element: element,
    );
  }
}
