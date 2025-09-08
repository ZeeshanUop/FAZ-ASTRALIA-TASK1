import 'package:flutter/material.dart';
import '../../../data/models/post.dart';
import '../../../data/services/post_services.dart';
enum LoadingState { idle, loading, error }

class PostsViewModel extends ChangeNotifier {
  final PostsService _service;
  final List<Post> _posts = [];
  int _start = 0;
  final int _limit = 10;
  bool _hasMore = true;
  LoadingState _state = LoadingState.idle;
  String? _error;

  PostsViewModel(this._service);

  List<Post> get posts => List.unmodifiable(_posts);
  bool get hasMore => _hasMore;
  LoadingState get state => _state;
  String? get error => _error;

  Future<void> loadInitial() async {
    _posts.clear();
    _start = 0;
    _hasMore = true;
    await loadMore();
  }

  Future<void> loadMore() async {
    if (!_hasMore || _state == LoadingState.loading) return;
    _state = LoadingState.loading;
    _error = null;
    notifyListeners();
    try {
      final newPosts = await _service.fetchPosts(start: _start, limit: _limit);
      if (newPosts.length < _limit) _hasMore = false;
      _posts.addAll(newPosts);
      _start += newPosts.length;
      _state = LoadingState.idle;
    } catch (e) {
      _error = e.toString();
      _state = LoadingState.error;
    }
    notifyListeners();
  }

  Future<void> retry() async {
    await loadMore();
  }
}
