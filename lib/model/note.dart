final String tableNotes = 'notes';

class NoteFields {
  static final List<String> values = [
    id, content, creationDate
  ];

  static final String id = '_id';
  static final String content = 'content';
  static final String creationDate = 'creationDate';
}

class Note {
  final int? id;
  final String content;
  final DateTime creationDate;

  const Note({
    this.id,
    required this.content,
    required this.creationDate,
  });

  Note copy({
    int? id,
    String? content,
    DateTime? creationDate,
  }) =>
      Note(
        id: id ?? this.id,
        content: content ?? this.content,
        creationDate: creationDate ?? this.creationDate,
      );

  static Note fromJson(Map<String, Object?> json) => Note(
    id: json[NoteFields.id] as int?,
    content: json[NoteFields.content] as String,
    creationDate: DateTime.parse(json[NoteFields.creationDate] as String),
  );

  Map<String, Object?> toJson() => {
    NoteFields.id: id,
    NoteFields.content: content,
    NoteFields.creationDate: creationDate.toIso8601String(),
  };
}