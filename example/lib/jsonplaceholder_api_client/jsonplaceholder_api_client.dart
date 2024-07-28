import 'post.dart';

abstract class JsonPlaceholderAPIClient {
  Future<List<Post>> getPosts({int? userId});
}
