import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';
import 'package:rest_api_generator/src/guards/annotated_clasess_guard.dart';
import 'package:source_gen/source_gen.dart';

import 'code_generators/http_client_initialization_code_generator.dart';
import 'code_generators/mixin_code_generator.dart';
import 'code_generators/request_functions_code_generator.dart';
import 'code_generators/single_request_function_code_generator/single_request_function_code_generator.dart';

final class RestApiGenerator extends GeneratorForAnnotation<RestApi> {
  const RestApiGenerator();

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    AnnotatedClassesGuard.validateClassMustBeAnnotated(element, annotation);
    AnnotatedClassesGuard.validateAnnotatedElementIsClass(element);
    return MixinCodeGenerator([
      HttpClientInitializationCodeGenerator(),
      RequestFunctionsCodeGenerator(SingleRequestFunctionCodeGenerator()),
    ]).generateFor(element as ClassElement);
  }
}
