import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'code_generators/http_client_code_generator.dart';
import 'code_generators/methods_impl_code_generator.dart';
import 'code_generators/mixin_code_generator.dart';
import 'code_generators/single_method_code_generator.dart';

final class RestApiGenerator extends GeneratorForAnnotation<RestApi> {
  const RestApiGenerator();

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (annotation.isNull) {
      throw InvalidGenerationSource(
        'The source annotation should be set!',
        element: element,
      );
    }

    if (element is! ClassElement) {
      throw InvalidGenerationSource(
        "'$RestApi' only support classes",
        element: element,
      );
    }

    return MixinCodeGenerator([
      HttpClientCodeGenerator(),
      MethodsImplCodeGenerator(SingleMethodCodeGenerator()),
    ]).generateFor(element);
  }
}
