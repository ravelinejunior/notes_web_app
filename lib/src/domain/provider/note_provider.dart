import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes_web_app/src/data/services/notes_api_service.dart';
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/model/tag.dart';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];
  List<Tag> _tags = [];
  bool _isLoading = false;
  final NotesApiService _apiService;
  String _sortBy = 'title';

  NoteProvider({required NotesApiService apiService})
      : _apiService = apiService {
    fetchNotes();
    fetchTags();
  }

  List<Note> get notes {
    List<Note> sortedNotes = List.from(_notes);
    sortedNotes.sort((a, b) {
      switch (_sortBy) {
        case 'title':
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case 'createdDate':
          return b.createdDate!.compareTo(a.createdDate!);
        case 'version':
          return b.version.compareTo(a.version);
        default:
          return 0;
      }
    });
    return sortedNotes;
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  List<Tag> get tags => _tags;
  bool get isLoading => _isLoading;

  Future<void> fetchNotes() async {
    _isLoading = true;
    notifyListeners();
    try {
      final responseNotes = await _apiService.getNotes();
      _notes = responseNotes;
    } catch (error) {
      log('Error fetching notes: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTags() async {
    try {
      final responseTags = await _apiService.getTags();
      _tags = responseTags;
    } catch (error) {
      log('Error fetching tags: $error');
    }
    notifyListeners();
  }

  Future<void> add(Note note) async {
    try {
      await _apiService.addNote(note);
      _notes.add(note);
    } catch (error) {
      log('Error adding note: $error');
      _notes.add(note);
    }
    notifyListeners();
  }

  Future<void> update(Note oldNote, Note newNote) async {
    int index = _notes.indexOf(oldNote);
    try {
      await _apiService.updateNote(oldNote.id!, newNote);
      if (index != -1) {
        _notes[index] = newNote;
      }
    } catch (error) {
      log('Error updating note: $error');
      _notes[index] = newNote;
    }
    notifyListeners();
  }

  Future<void> delete(Note note) async {
    try {
      await _apiService.deleteNote(note.id!);
      _notes.remove(note);
    } catch (error) {
      log('Error deleting note: $error');
      _notes.remove(note);
    }
    notifyListeners();
  }

  Future<void> addTag(Tag tag) async {
    try {
      await _apiService.addTag(tag);
      _tags.add(tag);
    } catch (error) {
      log('Error adding tag: $error');
    }
    notifyListeners();
  }

  Future<void> deleteTag(Tag tag) async {
    try {
      await _apiService.deleteTag(tag.id);
      _tags.remove(tag);
    } catch (error) {
      log('Error deleting tag: $error');
    }
    notifyListeners();
  }
}
