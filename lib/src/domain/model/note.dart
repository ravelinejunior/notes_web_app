import 'package:flutter/foundation.dart';
import 'package:notes_web_app/src/domain/model/tag.dart';

class Note {
  int? id;
  String title;
  String content;
  List<Tag> tags;

  Note({
    this.id,
    required this.title,
    required this.content,
    this.tags = const [],
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tags: (json['tags'] as List<dynamic>)
          .map((tag) => Tag.fromJson(tag as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'tags': tags.map((tag) => tag.toJson()).toList(),
    };
  }

  Note copyWith({
    int? id,
    String? title,
    String? content,
    List<Tag>? tags,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
    );
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] != null ? map['id'] as int : null,
      title: map['title'] as String,
      content: map['content'] as String,
      tags: List<Tag>.from(
        (map['tags'] as List<dynamic>).map<Tag>(
          (x) => Tag.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, tags: $tags}';
  }

  @override
  bool operator ==(covariant Note other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.content == content &&
        listEquals(other.tags, tags);
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ content.hashCode ^ tags.hashCode;
  }
}
