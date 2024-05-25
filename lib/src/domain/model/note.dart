import 'package:notes_web_app/src/domain/model/tag.dart';

class Note {
  int? id;
  String title;
  String content;
  List<Tag> tags;
  DateTime? createdDate;
  int version;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.tags = const [],
    required this.createdDate,
    this.version = 1,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => Tag.fromJson(tag as Map<String, dynamic>))
          .toList(),
      createdDate: DateTime.parse(json['createdDate']),
      version: json['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags.map((tag) => tag.toJson()).toList(),
      'createdDate': createdDate?.toIso8601String(),
      'version': version,
    };
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    List<Tag>? tags,
    DateTime? createdDate,
    int? version,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      createdDate: createdDate ?? this.createdDate,
      version: version ?? this.version,
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, tags: $tags}';
  }
}
