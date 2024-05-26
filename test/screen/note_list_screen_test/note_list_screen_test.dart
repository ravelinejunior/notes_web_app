import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lottie/lottie.dart';
import 'package:mockito/mockito.dart';
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/provider/note_provider.dart';
import 'package:notes_web_app/src/screen/note_list_page_screen/note_list_screen.dart';
import 'package:provider/provider.dart';

import '../../domain/provider/note_provider_test.mocks.dart';

void main() {
  group('NoteListScreen Tests', () {
    MockNotesApiService mockApiService;
    List<Note> testNotes;
    setUp(() {
      mockApiService = MockNotesApiService();
      testNotes = [
        Note(
          id: 1,
          title: 'Test Note 1',
          content: 'This is a test note',
          createdDate: DateTime.now(),
          version: 1,
        ),
        Note(
          id: 2,
          title: 'Test Note 2',
          content: 'This is another test note',
          createdDate: DateTime.now(),
          version: 1,
        ),
      ];

      // Mock getNotes method to return a Future with a list of test notes
      when(mockApiService.getNotes()).thenAnswer((_) async => testNotes);
    });
    testWidgets('Displays LottieBuilder when', (WidgetTester tester) async {
      mockApiService = MockNotesApiService();
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => NoteProvider(apiService: mockApiService),
          child: const MaterialApp(
            home: NoteListScreen(),
          ),
        ),
      );

      expect(find.byType(LottieBuilder), findsOneWidget);
    });

    testWidgets('Displays no notes message when there are no notes',
        (WidgetTester tester) async {
      mockApiService = MockNotesApiService();
      when(mockApiService.getNotes()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => NoteProvider(apiService: mockApiService),
          child: const MaterialApp(
            home: NoteListScreen(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('No notes available.'), findsOneWidget);
    });

    testWidgets('Displays list of notes', (WidgetTester tester) async {
      mockApiService = MockNotesApiService();
      testNotes = [
        Note(
          id: 1,
          title: 'Test Note 1',
          content: 'This is a test note',
          createdDate: DateTime.now(),
          version: 1,
        ),
        Note(
          id: 2,
          title: 'Test Note 2',
          content: 'This is another test note',
          createdDate: DateTime.now(),
          version: 1,
        ),
      ];
      when(mockApiService.getNotes()).thenAnswer((_) async => testNotes);
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => NoteProvider(apiService: mockApiService),
          child: const MaterialApp(
            home: NoteListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test Note 1'), findsOneWidget);
      expect(find.text('Test Note 2'), findsOneWidget);
    });
  });
}
