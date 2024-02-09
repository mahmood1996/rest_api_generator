import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:example/fake_api_client/fake_api_client.dart';
import 'package:exceptions/exceptions.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';

part 'fake_api_client_impl.g.dart';

@RestApi()
final class FakeAPIClientImpl
    with _$FakeAPIClientImplMixin
    implements FakeAPIClient {
  FakeAPIClientImpl(Dio dio) {
    _$setHttpClientInstance(dio);
  }

  @override
  @Request(
    method: 'GET',
    path: '/data',
    onFailedResponse: _onFailedResponse,
  )
  Future<Map<String, dynamic>> getData();

  static Future<Map<String, dynamic>> _onFailedResponse(Response response) {
    if (response.statusCode == 500) throw Exception(response.data.toString());
    throw ServerException(message: response.data.toString());
  }
}
