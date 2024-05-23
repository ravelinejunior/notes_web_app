import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes_web_app/src/data/services/notes_api_service.dart';
import 'package:notes_web_app/src/domain/model/note.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  bool _isLoading = false;
  final NotesApiService _apiService = NotesApiService();

  List<Note> get notes => _notes;
  bool get isLoading => _isLoading;

  NoteProvider() {
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _notes = await _apiService.getNotes();
    } catch (error) {
      log('Error fetching notes: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> add(Note note) async {
    try {
      await _apiService.addNote(note);
      _notes.add(note);
      notifyListeners();
    } catch (error) {
      log('Error adding note: $error');
    }
  }

  Future<void> update(Note oldNote, Note newNote) async {
    try {
      await _apiService.updateNote(oldNote.id!, newNote);
      int index = _notes.indexOf(oldNote);
      if (index != -1) {
        _notes[index] = newNote;
        notifyListeners();
      }
    } catch (error) {
      log('Error updating note: $error');
    }
  }

  Future<void> delete(Note note) async {
    try {
      await _apiService.deleteNote(note.id!);
      _notes.remove(note);
      notifyListeners();
    } catch (error) {
      log('Error deleting note: $error');
    }
  }
}
