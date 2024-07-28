import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:example/jsonplaceholder_api_client/jsonplaceholder_api_client.dart';
import 'package:example/jsonplaceholder_api_client/post.dart';
import 'package:exceptions/exceptions.dart';
import 'package:rest_api_annotation/rest_api_annotation.dart';

part 'jsonplaceholder_api_client_impl.g.dart';

@RestApi()
final class JsonPlaceholderAPIClientImpl
    with _$JsonPlaceholderAPIClientImplMixin
    implements JsonPlaceholderAPIClient {
  JsonPlaceholderAPIClientImpl(Dio dio) {
    _$setHttpClientInstance(dio);
  }

  @override
  @Request(
    method: 'GET',
    path: '/posts',
    onSuccessfulResponse: _onSuccessfulResponse,
  )
  Future<List<Post>> getPosts({
    @QueryParameter('userId') int? userId,
  });

  static FutureOr<List<Post>> _onSuccessfulResponse(Response response) {
    Iterable<dynamic> data = response.data;
    return data.map((e) => Post.fromJson(e)).toList();
  }
}
