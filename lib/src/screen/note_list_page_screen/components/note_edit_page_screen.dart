import 'package:flutter/material.dart';
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/provider/note_provider.dart';
import 'package:notes_web_app/src/screen/note_list_page_screen/note_list_screen.dart';
import 'package:provider/provider.dart';

class NoteEditPageScreen extends StatefulWidget {
  const NoteEditPageScreen({super.key, this.note});
  final Note? note;

  @override
  State<NoteEditPageScreen> createState() => _NoteEditPageScreen();
}

class _NoteEditPageScreen extends State<NoteEditPageScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final noteProvider =
                    Provider.of<NoteProvider>(context, listen: false);
                if (widget.note == null) {
                  noteProvider.add(
                    Note(
                      title: _titleController.text,
                      content: _contentController.text,
                    ),
                  );
                } else {
                  noteProvider.update(
                    widget.note!,
                    Note(
                      id: widget.note!.id,
                      title: _titleController.text,
                      content: _contentController.text,
                    ),
                  );
                }
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => const NoteListScreen(),
                  ),
                  (route) => false,
                );
              },
              child: Text(widget.note == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
