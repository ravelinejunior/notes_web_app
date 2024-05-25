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
  final String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        actions: [
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
            return Center(child: CircularProgressIndicator());
          } else if (noteProvider.notes.isEmpty) {
            return Center(child: Text('No notes available.'));
          } else {
            final notes = noteProvider.notes
                .where((note) =>
                    note.title
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    note.content
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                .toList();
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  leading: Icon(Icons.book),
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
      icon: Icon(Icons.close),
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
              leading: Icon(Icons.book),
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
              leading: Icon(Icons.book),
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
