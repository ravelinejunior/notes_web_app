import 'package:flutter/material.dart';
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/model/tag.dart';
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
  List<Tag> _selectedTags = [];

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
    final tags = Provider.of<NoteProvider>(context).tags;

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
            const SizedBox(height: 20),
            Wrap(
              children: tags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    label: Text(tag.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTags.add(tag);
                        } else {
                          _selectedTags.remove(tag);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final noteProvider =
                    Provider.of<NoteProvider>(context, listen: false);
                final note = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                  tags: _selectedTags,
                );
                if (widget.note == null) {
                  noteProvider.add(note);
                } else {
                  noteProvider.update(widget.note!, note);
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
