import 'package:analyzer/dart/element/element.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';
import 'package:rest_api_generator/src/utils/utils.dart';

import 'code_generator.dart';

final class RequestFunctionsCodeGenerator
    implements CodeGenerator<ClassElement> {
  RequestFunctionsCodeGenerator(this._methodCodeGenerator);

  final CodeGenerator<MethodElement> _methodCodeGenerator;

  @override
  String generateFor(ClassElement element) {
    final buffer = StringBuffer();

    buffer.writeAll([
      ..._methodsAnnotatedWith<Request>(element.methods)
          .map((e) => _methodCodeGenerator.generateFor(e)),
      '\n',
      _buildOnDioException(),
    ]);

    return buffer.toString();
  }

  Iterable<MethodElement> _methodsAnnotatedWith<AnnotationType>(
    Iterable<MethodElement> elements,
  ) {
    return Utils.getElementsAnnotatedWith<AnnotationType>(elements)
        .whereType<MethodElement>();
  }

  String _buildOnDioException() {
    return 'FutureOr<ReturnType> _onDioException<ReturnType>({\n'
        'required DioException exception,\n'
        'FutureOr<ReturnType> Function(Response response)? onFailedResponse,\n'
        '}) async {\n'
        'if (exception.response == null) throw NetworkException();\n'
        'if (exception.error is SocketException) throw NetworkException();\n'
        'final response = exception.response!;\n'
        'if (onFailedResponse != null) return await onFailedResponse(response);\n'
        'throw ServerException(message: response.data.toString());\n'
        '}\n';
  }
}
