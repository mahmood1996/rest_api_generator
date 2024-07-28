import 'package:dio/dio.dart';
import 'package:example/jsonplaceholder_api_client/jsonplaceholder_api_client.dart';
import 'package:example/jsonplaceholder_api_client/jsonplaceholder_api_client_impl.dart';
import 'package:example/jsonplaceholder_api_client/post.dart';
import 'package:exceptions/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';

void main() {
  late Dio instance;
  late JsonPlaceholderAPIClient apiClient;

  setUpAll(() => nock.init());

  setUp(() {
    instance = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      headers: {
        'Content-Type': 'application/json',
      },
      queryParameters: {},
    ));

    apiClient = JsonPlaceholderAPIClientImpl(instance);

    nock.cleanAll();
  });

  group('json place holder api client', () {
    test('200 OK without userId', () async {
      nock(instance.options.baseUrl).get('/posts?userId=').reply(
        200,
        [
          {
            "userId": 1,
            "id": 1,
            "title": "title",
            "body": "body",
          }
        ],
        headers: {'Content-Type': 'application/json'},
      );

      var posts = await apiClient.getPosts();

      expect(
        posts.firstOrNull,
        predicate<Post>((post) {
          expect(post.id, 1);
          expect(post.userId, 1);
          expect(post.title, 'title');
          expect(post.body, 'body');
          return true;
        }),
      );
    });

    test('200 OK with userId', () async {
      nock(instance.options.baseUrl).get('/posts?userId=5').reply(
        200,
        [
          {
            "userId": 5,
            "id": 5,
            "title": "title",
            "body": "body",
          }
        ],
        headers: {'Content-Type': 'application/json'},
      );

      var posts = await apiClient.getPosts(userId: 5);

      expect(
        posts.firstOrNull,
        predicate<Post>((post) {
          expect(post.id, 5);
          expect(post.userId, 5);
          expect(post.title, 'title');
          expect(post.body, 'body');
          return true;
        }),
      );
    });

    test('throws ServerException on non successful response', () async {
      nock(instance.options.baseUrl).get('/posts?userId=').reply(400, 'error');

      expect(
        () async => await apiClient.getPosts(),
        throwsA(predicate<ServerException>((exc) => exc.message == 'error')),
      );
    });
  });
}
