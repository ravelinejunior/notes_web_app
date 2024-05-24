import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/model/tag.dart';

class NotesApiService {
  static const String baseUrl = 'http://localhost:3000/notes';
  static const String tagsUrl = 'http://localhost:3000/tags';

  Future<List<Note>> getNotes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<Note> notes =
          responseData.map((data) => Note.fromJson(data)).toList();
      return notes;
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<Note> getNoteById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        return Note.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to load note with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load note: $e');
    }
  }

  Future<void> addNote(Note note) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(note.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add note');
    }
  }

  Future<void> updateNote(int id, Note note) async {
    final client = http.Client();
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(note.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update note');
      }
    } catch (e) {
      log('Error updating note: $e');
    } finally {
      client.close();
    }
  }

  Future<void> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete note');
    }
  }

  Future<List<Tag>> getTags() async {
    final uri = Uri.parse(tagsUrl);
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load tags');
    }

    final jsonList = jsonDecode(response.body) as List;
    return jsonList.map((tag) => Tag.fromJson(tag)).toList();
  }

  Future<void> addTag(Tag tag) async {
    final response = await http.post(
      Uri.parse(tagsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(tag.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add tag');
    }
  }

  Future<void> associateTagsWithNote({
    required int noteId,
    required List<Tag> tags,
  }) async {
    final List<int> tagIds =
        tags.map((tag) => tag.id).toList(); // Assuming Tag has an 'id' property
    final response = await http.post(
      Uri.parse('$baseUrl/$noteId/tags'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'tagIds': tagIds}),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to associate tags with note');
    }
  }

  Future<void> deleteTag(int id) async {
    final response = await http.delete(Uri.parse('$tagsUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete tag');
    }
  }
}
