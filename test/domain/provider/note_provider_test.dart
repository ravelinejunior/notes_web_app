import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notes_web_app/src/data/services/notes_api_service.dart';
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/model/tag.dart';
import 'package:notes_web_app/src/domain/provider/note_provider.dart';

import 'note_provider_test.mocks.dart';

@GenerateMocks([NotesApiService])
void main() {
  late NoteProvider noteProvider;
  late MockNotesApiService mockNotesApiService;

  setUp(() {
    mockNotesApiService = MockNotesApiService();
    noteProvider = NoteProvider(apiService: mockNotesApiService);
  });

  group('fetchNotes', () {
    final notes = [
      Note(
        id: 1,
        title: 'Test',
        content: 'Content',
        createdDate: DateTime.now(),
      )
    ];

    test('Should fetch notes from the API', () async {
      when(mockNotesApiService.getNotes()).thenAnswer((_) async => notes);

      await noteProvider.fetchNotes();

      expect(noteProvider.notes, notes);
      expect(noteProvider.isLoading, false);
      verify(mockNotesApiService.getNotes()).called(2);
    });

    test('Should log error when fetching notes fails', () async {
      when(mockNotesApiService.getNotes())
          .thenThrow(Exception('Error fetching notes'));

      await noteProvider.fetchNotes();

      expect(noteProvider.notes, []);
      expect(noteProvider.isLoading, false);
      verify(mockNotesApiService.getNotes()).called(2);
    });
  });

  group('add', () {
    final note = Note(
      id: 1,
      title: 'Test',
      content: 'Content',
      createdDate: DateTime.now(),
    );

    test('Should add note using the API', () async {
      when(mockNotesApiService.addNote(note)).thenAnswer((_) async {});

      await noteProvider.add(note);

      expect(noteProvider.notes.contains(note), true);
      verify(mockNotesApiService.addNote(note)).called(1);
    });

    test('Should log error when adding note fails', () async {
      when(mockNotesApiService.addNote(note))
          .thenThrow(Exception('Failed to add note'));

      await noteProvider.add(note);

      expect(noteProvider.notes.contains(note), true);
      verify(mockNotesApiService.addNote(note)).called(1);
    });
  });

  group('update', () {
    final oldNote = Note(
      id: 1,
      title: 'Old Test',
      content: 'Old Content',
      createdDate: DateTime.now(),
    );
    final newNote = Note(
      id: 1,
      title: 'New Test',
      content: 'New Content',
      createdDate: DateTime.now(),
    );

    setUp(() {
      noteProvider.notes.add(oldNote);
    });

    test('Should update note using the API', () async {
      when(mockNotesApiService.updateNote(oldNote.id!, newNote))
          .thenAnswer((_) async {});

      await noteProvider.update(oldNote, newNote);

      expect(noteProvider.notes.contains(newNote), true);
      verify(mockNotesApiService.updateNote(oldNote.id!, newNote)).called(1);
    });

    test('Should log error when updating note fails', () async {
      when(mockNotesApiService.updateNote(oldNote.id!, newNote))
          .thenThrow(Exception('Failed to update note'));

      await noteProvider.update(oldNote, newNote);

      expect(noteProvider.notes.contains(newNote), true);
      verify(mockNotesApiService.updateNote(oldNote.id!, newNote)).called(1);
    });
  });

  group('delete', () {
    final note = Note(
      id: 1,
      title: 'Test',
      content: 'Content',
      createdDate: DateTime.now(),
    );

    setUp(() {
      noteProvider.notes.add(note);
    });

    test('Should delete note using the API', () async {
      when(mockNotesApiService.deleteNote(note.id!)).thenAnswer((_) async {});

      await noteProvider.delete(note);

      expect(noteProvider.notes.contains(note), false);
      verify(mockNotesApiService.deleteNote(note.id!)).called(1);
    });

    test('Should log error when deleting note fails', () async {
      when(mockNotesApiService.deleteNote(note.id!))
          .thenThrow(Exception('Failed to delete note'));

      await noteProvider.delete(note);

      expect(noteProvider.notes.contains(note), false);
      verify(mockNotesApiService.deleteNote(note.id!)).called(1);
    });
  });

  group('fetchTags', () {
    final tags = [Tag(id: 1, name: 'Test Tag')];

    test('Should fetch tags from the API', () async {
      when(mockNotesApiService.getTags()).thenAnswer((_) async => tags);

      await noteProvider.fetchTags();

      expect(noteProvider.tags, tags);
      verify(mockNotesApiService.getTags()).called(2);
    });

    test('Should log error when fetching tags fails', () async {
      when(mockNotesApiService.getTags())
          .thenThrow(Exception('Error fetching tags'));

      await noteProvider.fetchTags();

      expect(noteProvider.tags, []);
      verify(mockNotesApiService.getTags()).called(2);
    });
  });

  group('addTag', () {
    final tag = Tag(id: 1, name: 'Test Tag');

    test('Should add tag using the API', () async {
      when(mockNotesApiService.addTag(tag)).thenAnswer((_) async {});

      await noteProvider.addTag(tag);

      expect(noteProvider.tags.contains(tag), true);
      verify(mockNotesApiService.addTag(tag)).called(1);
    });

    test('Should log error when adding tag fails', () async {
      when(mockNotesApiService.addTag(tag))
          .thenThrow(Exception('Failed to add tag'));

      await noteProvider.addTag(tag);

      expect(noteProvider.tags.contains(tag), false);
      verify(mockNotesApiService.addTag(tag)).called(1);
    });
  });

  group('deleteTag', () {
    final tag = Tag(id: 1, name: 'Test Tag');

    setUp(() {
      noteProvider.tags.add(tag);
    });

    test('Should delete tag using the API', () async {
      when(mockNotesApiService.deleteTag(tag.id)).thenAnswer((_) async {});

      await noteProvider.deleteTag(tag);

      expect(noteProvider.tags.contains(tag), false);
      verify(mockNotesApiService.deleteTag(tag.id)).called(1);
    });

    test('Should log error when deleting tag fails', () async {
      when(mockNotesApiService.deleteTag(tag.id!))
          .thenThrow(Exception('Failed to delete tag'));

      await noteProvider.deleteTag(tag);

      expect(noteProvider.tags.contains(tag), true);
      verify(mockNotesApiService.deleteTag(tag.id)).called(1);
    });
  });
}
