import 'package:flutter/material.dart';
import 'package:notes_web_app/src/domain/provider/note_provider.dart';
import 'package:notes_web_app/src/screen/note_list_page_screen/components/note_detail_page_screen.dart';
import 'package:notes_web_app/src/screen/note_list_page_screen/components/note_edit_page_screen.dart';
import 'package:provider/provider.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              Provider.of<NoteProvider>(context, listen: false)
                  .setSortBy(value);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'title',
                child: Text('Sort by Title'),
              ),
              PopupMenuItem(
                value: 'createdDate',
                child: Text('Sort by Created Date'),
              ),
              PopupMenuItem(
                value: 'version',
                child: Text('Sort by Version'),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NoteSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Consumer<NoteProvider>(
        builder: (context, noteProvider, child) {
          if (noteProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (noteProvider.notes.isEmpty) {
            return const Center(child: Text('No notes available.'));
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

class NoteSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        final results = noteProvider.notes
            .where((note) =>
                note.title.toLowerCase().contains(query.toLowerCase()) ||
                note.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final note = results[index];
            return ListTile(
              leading: const Icon(Icons.book),
              title: Text(note.title),
              subtitle: Text(note.content),
              contentPadding: const EdgeInsets.all(8),
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
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        final suggestions = noteProvider.notes
            .where((note) =>
                note.title.toLowerCase().contains(query.toLowerCase()) ||
                note.content.toLowerCase().contains(query.toLowerCase()))
            .toList();
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final note = suggestions[index];
            return ListTile(
              leading: const Icon(Icons.book),
              title: Text(note.title),
              subtitle: Text(note.content),
              contentPadding: const EdgeInsets.all(8),
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
      },
    );
  }
}
