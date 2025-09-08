import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/post_view_model.dart';
import '../widget/post_card.dart';
import '../widget/post_skeleton.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({super.key});

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  late final ScrollController _sc;

  @override
  void initState() {
    super.initState();
    _sc = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<PostsViewModel>();
      if (vm.posts.isEmpty) vm.loadInitial();
    });
  }

  void _onScroll() {
    final vm = context.read<PostsViewModel>();
    if (_sc.position.pixels >=
        _sc.position.maxScrollExtent - 200 &&
        vm.hasMore &&
        vm.state != LoadingState.loading) {
      vm.loadMore();
    }
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Posts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.deepOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
      ),
      body: Consumer<PostsViewModel>(
        builder: (context, vm, _) {
          // 🔄 Loading state (first page)
          if (vm.state == LoadingState.loading &&
              vm.posts.isEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: 5,
              itemBuilder: (_, __) => const PostSkeleton(),
            );
          }

          // ⚠️ Error state (first page)
          if (vm.state == LoadingState.error &&
              vm.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline,
                      size: 60,
                      color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 12),
                  Text(vm.error ?? 'Something went wrong'),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: vm.retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // 📭 Empty state
          if (vm.posts.isEmpty) {
            return const Center(
              child: Text(
                'No posts available',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            );
          }

          // 📜 Success state with paging
          return ListView.builder(
            controller: _sc,
            padding: const EdgeInsets.all(12),
            itemCount: vm.posts.length + (vm.hasMore ? 1 : 0),
            itemBuilder: (context, idx) {
              if (idx < vm.posts.length) {
                return PostCard(post: vm.posts[idx]);
              }

              // Retry if error occurred during loadMore
              if (vm.state == LoadingState.error) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton.icon(
                    onPressed: vm.retry,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry loading more'),
                  ),
                );
              }

              // Loader at bottom
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            },
          );
        },
      ),
    );
  }
}
