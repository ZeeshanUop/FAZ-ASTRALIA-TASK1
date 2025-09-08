import 'dart:convert';
import '../models/post.dart';
import 'package:http/http.dart'as http;
class PostsService {
  static const _base = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> fetchPosts({int start = 0, int limit = 10}) async {
    final uri = Uri.parse('$_base?_start=$start&_limit=$limit');
    final res = await http.get(uri).timeout(const Duration(seconds: 10));
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list.map((e) => Post.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load posts (${res.statusCode})');
    }
  }
}
