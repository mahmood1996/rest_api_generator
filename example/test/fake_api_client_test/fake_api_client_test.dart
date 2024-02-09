import 'package:dio/dio.dart';
import 'package:example/fake_api_client/fake_api_client.dart';
import 'package:example/fake_api_client/fake_api_client_impl.dart';
import 'package:exceptions/exceptions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nock/nock.dart';

void main() {
  late Dio instance;
  late FakeAPIClient fakeAPIClient;

  setUpAll(() => nock.init());

  setUp(() {
    nock.cleanAll();

    instance = Dio(BaseOptions(
      baseUrl: 'https://example.com/api',
      headers: {},
      queryParameters: {},
    ));

    fakeAPIClient = FakeAPIClientImpl(instance);
  });

  test('200 Ok', () async {
    nock(instance.options.baseUrl).get('/data').reply(
      200,
      {"status": "Ok"},
      headers: {'Content-Type': 'application/json'},
    );

    expect(await fakeAPIClient.getData(), {"status": "Ok"});
  });

  test('throws NetworkException()', () async {
    nock(instance.options.baseUrl).get('/data').throwNetworkError();

    expect(
      () async => await fakeAPIClient.getData(),
      throwsA(isA<NetworkException>()),
    );
  });

  test('throws ServerException()', () async {
    nock(instance.options.baseUrl).get('/data').reply(422, 'error');

    expect(
      () async => await fakeAPIClient.getData(),
      throwsA(predicate<ServerException>((e) => e.message == 'error')),
    );
  });

  test('onFailedResponse', () async {
    nock(instance.options.baseUrl).get('/data').reply(500, 'error');

    expect(
      () async => await fakeAPIClient.getData(),
      throwsA(isA<Exception>()),
    );
  });
}
