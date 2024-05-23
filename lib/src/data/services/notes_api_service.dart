import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:notes_web_app/src/domain/model/note.dart';

class NotesApiService {
  static const String baseUrl = 'http://localhost:3000/notes';

  Future<List<Note>> getNotes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      return list.map((note) => Note.fromJson(note)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  Future<Note> getNoteById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Note.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load note');
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
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(note.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
  }

  Future<void> deleteNote(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete note');
    }
  }
}
