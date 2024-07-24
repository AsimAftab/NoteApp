import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/database_helper.dart';
import '../widgets/note_widget.dart'; // Ensure this is the correct path
import 'note_screen.dart'; // Ensure this is pointing to the correct file

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  Future<List<Note>?> _fetchNotes() async {
    return await DatabaseHelper.getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to NoteScreen for adding a new note
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteScreen()),
          );
          // Refresh the notes list after returning
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Note>?>(
        future: _fetchNotes(),
        builder: (context, snapshot) {
          // Show a loading indicator while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show an error message if there's an error
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If data is available
          if (snapshot.hasData) {
            final notes = snapshot.data;
            if (notes != null && notes.isNotEmpty) {
              return ListView.separated(
                itemCount: notes.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteWidget(
                    note: note,
                    onTap: () async {
                      // Navigate to NoteScreen for editing the selected note
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteScreen(note: note),
                        ),
                      );
                      // Refresh the notes list after returning
                      setState(() {});
                    },
                    onLongPress: () async {
                      // Show a dialog for confirming note deletion
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Are you sure you want to delete this note?'),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  await DatabaseHelper.deleteNote(note);
                                  Navigator.pop(context);
                                  // Refresh the notes list after deletion
                                  setState(() {});
                                },
                                child: const Text('Yes'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            }
            // Show a message when no notes are available
            return const Center(child: Text('No notes yet'));
          }
          // Show an empty state if the data is not available
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
