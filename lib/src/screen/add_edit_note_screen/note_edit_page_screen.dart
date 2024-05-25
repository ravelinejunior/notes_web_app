import 'package:flutter/cupertino.dart';
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
  bool _isButtonAnimating = false;

  @override
  void initState() {
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedTags = widget.note!.tags;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Tag> tags = Provider.of<NoteProvider>(context).tags;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.all(10),
                  hintText: 'Enter your title here...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _contentController,
                minLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                  ),
                  alignLabelWithHint: true,
                  contentPadding: const EdgeInsets.all(10),
                  hintText: 'Enter your content here...',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  isDense: true,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  hintMaxLines: 5,
                ),
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
                      surfaceTintColor: Colors.white,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tag);
                          } else {
                            _selectedTags.remove(tag);
                          }
                        });
                      },
                      selectedColor:
                          Theme.of(context).primaryColor.withOpacity(0.5),
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).textTheme.bodyLarge!.color,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: AnimatedOpacity(
                  curve: Curves.easeInBack,
                  duration: const Duration(milliseconds: 700),
                  opacity: _isButtonAnimating ? 0.0 : 1.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_titleController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a title'),
                          ),
                        );
                        return;
                      }

                      if (_contentController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a content'),
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _isButtonAnimating = true;
                      });
                      final noteProvider =
                          Provider.of<NoteProvider>(context, listen: false);
                      Note note = Note(
                        title: _titleController.text,
                        content: _contentController.text,
                        tags: _selectedTags,
                        createdDate: DateTime.now(),
                      );
                      if (widget.note == null) {
                        await noteProvider.add(note);
                      } else {
                        note.id = widget.note!.id ?? noteProvider.notes.length;
                        note.version = widget.note!.version + 1;
                        await noteProvider.update(widget.note!, note);
                      }
                      // Wait for 2 seconds before navigating to the list screen
                      await Future.delayed(const Duration(milliseconds: 1000));
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const NoteListScreen(),
                        ),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: _isButtonAnimating ? 0 : 2,
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: _isButtonAnimating ? 0.0 : 1.0,
                      child: Text(widget.note == null ? 'Add' : 'Update'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
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
