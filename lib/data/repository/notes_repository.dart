import 'package:hive/hive.dart';
import '../../core/constant.dart';
import '../models/notes.dart';

class NotesRepository {
  final Box<Note> _box = Hive.box<Note>(AppConstants.notesBox);

  List<Note> getAll() {
    final items = _box.values.toList();
    items.sort((a,b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<void> add(Note note) => _box.put(note.id, note);
  Future<void> update(Note note) => _box.put(note.id, note);
  Future<void> delete(String id) => _box.delete(id);
}
