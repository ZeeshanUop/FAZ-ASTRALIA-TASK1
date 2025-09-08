import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/notes.dart';
import '../../post/view/post_list_screen.dart';
import '../../settings/view/theme_playground_screen.dart';
import '../view_model/notes_model.dart';
import '../widget/note_card.dart';
import 'note_edit_screen.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotesViewModel>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens_outlined),
            tooltip: "Theme Playground",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ThemePlaygroundScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: "Posts",
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PostsListScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NoteEditScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.notes.isEmpty
            ? _buildEmptyState(context)
            : ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: vm.notes.length,
          itemBuilder: (context, i) {
            final note = vm.notes[i];
            return Dismissible(
              key: ValueKey(note.id),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red, Colors.deepOrange],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (_) async {
                _deleteWithUndo(context, note);
                return false;
              },
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => NoteEditScreen(editing: note),
                  ),
                ),
                child: NoteCard(note: note),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined,
              size: 80, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            "No notes yet",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tap + to create your first note.",
            style: TextStyle(color: Colors.black45),
          ),
        ],
      ),
    );
  }

  void _deleteWithUndo(BuildContext context, Note note) {
    final vm = context.read<NotesViewModel>();
    vm.deleteNote(note);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => vm.undoDelete(note),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
