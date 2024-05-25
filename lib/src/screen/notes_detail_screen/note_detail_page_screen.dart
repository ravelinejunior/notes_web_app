import 'package:flutter/material.dart';
import 'package:notes_web_app/src/domain/model/note.dart';
import 'package:notes_web_app/src/domain/provider/note_provider.dart';
import 'package:notes_web_app/src/utils/pdf_helper.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../add_edit_note_screen/note_edit_page_screen.dart';

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
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoteEditPageScreen(note: note),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<NoteProvider>(context, listen: false).delete(note);
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              final pdfData = await generateSinglePdf(note);
              await Printing.layoutPdf(onLayout: (format) => pdfData);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.content),
            const SizedBox(height: 20),
            Wrap(
              children: note.tags.map((tag) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    label: Text(tag.name),
                    selected: true,
                    onSelected: null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
