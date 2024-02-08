import 'dart:async';

import 'package:rest_api_annotation/rest_api_annotation.dart';
import 'package:rest_api_generator/src/rest_api_generator.dart';
import 'package:source_gen_test/src/build_log_tracking.dart';
import 'package:source_gen_test/src/init_library_reader.dart';
import 'package:source_gen_test/src/test_annotated_classes.dart';

Future<void> main() async {
  final reader = await initializeLibraryReaderForDirectory(
    'test/src',
    'test_src.dart',
  );

  initializeBuildLogTracking();
  testAnnotatedElements<RestApi>(
    reader,
    const RestApiGenerator(),
  );
}
