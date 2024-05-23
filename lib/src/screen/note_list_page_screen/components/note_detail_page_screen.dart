import 'package:flutter/material.dart';
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/provider/note_provider.dart';
import 'package:provider/provider.dart';
import 'note_edit_page_screen.dart';

class NoteDetailPageScreen extends StatelessWidget {
  final Note note;

  const NoteDetailPageScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoteEditPageScreen(note: note),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<NoteProvider>(context, listen: false).delete(note);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(note.content),
      ),
    );
  }
}
