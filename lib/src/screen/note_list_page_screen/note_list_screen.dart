import 'package:flutter/material.dart';
import 'package:notes_web_app/src/domain/provider/note_provider.dart';
import 'package:notes_web_app/src/screen/note_list_page_screen/components/note_detail_page_screen.dart';
import 'package:notes_web_app/src/screen/note_list_page_screen/components/note_edit_page_screen.dart';
import 'package:notes_web_app/src/utils/pdf_helper.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class NoteListScreen extends StatelessWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          if (noteProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (noteProvider.notes.isEmpty) {
            return Center(child: Text('No notes available.'));
          } else {
            return ListView.builder(
              itemCount: noteProvider.notes.length,
              itemBuilder: (context, index) {
                final note = noteProvider.notes[index];
                return ListTile(
                  title: Text(note.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NoteDetailPageScreen(note: note),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditPageScreen(),
            ),
          );
        },
      ),
    );
  }
}
