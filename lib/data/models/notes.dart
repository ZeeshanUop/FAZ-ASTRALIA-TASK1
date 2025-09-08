import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
class Note {
  String id;
  String title;
  String description;
  DateTime createdAt;

  Note({
    String? id,
    required this.title,
    required this.description,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Note.fromMap(Map<dynamic, dynamic> map) => Note(
    id: map['id'] as String,
    title: map['title'] as String,
    description: map['description'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
  );
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 0;

  @override
  Note read(BinaryReader reader) {
    final map = Map<String, dynamic>.from(reader.readMap());
    return Note.fromMap(map);
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.writeMap(obj.toMap());
  }
}
