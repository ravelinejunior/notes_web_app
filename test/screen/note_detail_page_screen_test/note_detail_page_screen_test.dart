import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:notes_web_app/src/data/services/notes_api_service.dart';
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/provider/note_provider.dart';
import 'package:notes_web_app/src/screen/note_list_page_screen/note_list_screen.dart';
import 'package:notes_web_app/src/screen/notes_detail_screen/note_detail_page_screen.dart';
import 'package:provider/provider.dart';

import 'note_detail_page_screen_test.mocks.dart';

@GenerateMocks([NotesApiService, NoteProvider])
void main() {
  group('NoteDetailPageScreen Tests', () {
    late MockNoteProvider mockNoteProvider;
    late Note testNote;

    setUp(() {
      mockNoteProvider = MockNoteProvider();
      testNote = Note(
        id: 1,
        title: 'Test Note',
        content: 'This is a test note.',
        createdDate: DateTime.now(),
        version: 1,
        tags: [],
      );
    });

    Widget createWidgetUnderTest() {
      return ChangeNotifierProvider<NoteProvider>.value(
        value: mockNoteProvider,
        child: MaterialApp(
          home: NoteDetailPageScreen(note: testNote),
        ),
      );
    }

    testWidgets('Displays note details', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Test Note'), findsAtLeast(2));
      expect(find.text('This is a test note.'), findsOneWidget);
    });

    testWidgets(
        'Shows delete confirmation dialog when delete button is pressed',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Confirm Delete'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this note?'),
          findsOneWidget);
    });
  });
}
