import 'package:flutter/material.dart';
import '../../../data/models/notes.dart';
import '../../../data/repository/notes_repository.dart';

class NotesViewModel extends ChangeNotifier {
  final NotesRepository _repo;
  List<Note> _notes = [];
  bool _isLoading = true;

  NotesViewModel(this._repo);

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();
    _notes = _repo.getAll();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    if (note.title.trim().isEmpty) throw Exception('Title required');
    await _repo.add(note);
    await load();
  }

  Future<void> updateNote(Note note) async {
    if (note.title.trim().isEmpty) throw Exception('Title required');
    await _repo.update(note);
    await load();
  }

  Future<void> deleteNote(Note note) async {
    await _repo.delete(note.id);
    await load();
  }

  Future<void> undoDelete(Note note) async {
    await _repo.add(note);
    await load();
  }
}
