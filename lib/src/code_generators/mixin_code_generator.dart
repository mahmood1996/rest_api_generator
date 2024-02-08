import 'package:analyzer/dart/element/element.dart';

import 'code_generator.dart';

final class MixinCodeGenerator implements CodeGenerator<ClassElement> {
  MixinCodeGenerator(this._implGenerators);

  late final List<CodeGenerator> _implGenerators;

  @override
  String generateFor(ClassElement element) {
    return (StringBuffer()
          ..writeAll([
            'mixin _\$${element.name}Mixin {\n',
            ..._implGenerators.map((e) => e.generateFor(element)),
            '}\n',
          ]))
        .toString();
  }
}
