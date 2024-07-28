import 'package:analyzer/dart/element/element.dart';

import 'code_generator.dart';

final class HttpClientInitializationCodeGenerator
    implements CodeGenerator<ClassElement> {
  @override
  String generateFor(ClassElement _) {
    return 'late final Dio _dio;\n'
        '\n'
        'void _\$setHttpClientInstance(Dio dio) => _dio = dio;\n\n';
  }
}
