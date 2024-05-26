import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:notes_web_app/src/screen/add_edit_note_screen/note_edit_page_screen.dart';
import 'package:provider/provider.dart';
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/model/tag.dart';
import 'package:notes_web_app/src/domain/provider/note_provider.dart';
import 'package:notes_web_app/src/screen/note_list_page_screen/note_list_screen.dart';

import '../note_detail_page_screen_test/note_detail_page_screen_test.mocks.dart';

void main() {
  group('NoteEditPageScreen Tests', () {
    late MockNoteProvider mockNoteProvider;
    late Note testNote;
    late Tag testTag;

    setUp(() {
      mockNoteProvider = MockNoteProvider();
      testTag = Tag(name: 'Test Tag', id: 1);
      testNote = Note(
        id: 1,
        title: 'Test Note',
        content: 'This is a test note.',
        createdDate: DateTime.now(),
        version: 1,
        tags: [testTag],
      );

      when(mockNoteProvider.tags).thenReturn([testTag]);
    });

    Widget createWidgetUnderTest({Note? note}) {
      return ChangeNotifierProvider<NoteProvider>.value(
        value: mockNoteProvider,
        child: MaterialApp(
          home: NoteEditPageScreen(note: note),
        ),
      );
    }

    testWidgets('Displays note details when editing an existing note',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest(note: testNote));
      await tester.pumpAndSettle();

      expect(find.text('Edit Note'), findsOneWidget);
      expect(find.text('Test Note'), findsOneWidget);
      expect(find.text('This is a test note.'), findsOneWidget);
      expect(find.text('Test Tag'), findsOneWidget);
    });

    testWidgets('Displays empty fields when adding a new note',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Add Note'), findsOneWidget);
      expect(find.text('Enter your title here...'), findsOneWidget);
      expect(find.text('Enter your content here...'), findsOneWidget);
      expect(find.text('Test Tag'), findsOneWidget);
    });

    testWidgets('Shows error if title is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.enterText(find.byType(TextFormField).last, 'Some content');
      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(find.text('Please enter a title'), findsOneWidget);
    });

    testWidgets('Shows error if content is empty', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Some title');
      await tester.enterText(find.byType(TextFormField).last, '');
      await tester.tap(find.text('Add'));
      await tester.pump();

      expect(find.text('Please enter a content'), findsOneWidget);
    });
  });
}
