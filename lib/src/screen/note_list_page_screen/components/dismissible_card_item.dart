import 'package:flutter/material.dart';
import 'package:notes_web_app/src/domain/model/note.dart';

class DismissibleCard extends StatelessWidget {
  final Note item;
  final VoidCallback onDismissed;

  const DismissibleCard(
      {super.key, required this.item, required this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.title),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDismissed();
      },
      background: Container(color: Colors.red),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Confirm'),
                  content:
                      const Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false
                          // ignore: avoid_print
                          ),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Yes'),
                    ),
                  ],
                ));
      },
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          title: Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(item.content),
          leading: const Icon(Icons.label, color: Colors.blue),
        ),
      ),
    );
  }
}
