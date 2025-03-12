import 'package:database_w_supabase/note.dart';
import 'package:database_w_supabase/note_database.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  // notes db
  final notesDatabase = NoteDatabase();
  //text Controller
  final noteController = TextEditingController();

  //user wants to add new note
  void addNewNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Note'),
        content: TextField(
          controller: noteController,
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Cancel"),
          ),

          //save button
          TextButton(
            onPressed: () {
              //create a new note
              final newNote = Note(content: noteController.text);
              //save the db
              notesDatabase.createNote(newNote);

              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  //user wants to update note
  void updateNote(Note note) {
    noteController.text = note.content;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Note'),
        content: TextField(
          controller: noteController,
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Cancel"),
          ),

          //save button
          TextButton(
            onPressed: () {
              //save the db
              notesDatabase.updateNote(note, noteController.text);

              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  //user wants to delete note
  void deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        actions: [
          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Cancel"),
          ),

          //save button
          TextButton(
            onPressed: () {
              //save the db
              notesDatabase.deleteNote(note);

              Navigator.pop(context);
              noteController.clear();
            },
            child: const Text("Delete"),
          )
        ],
      ),
    );
  }

  //build note
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Notes"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewNote,
        child: const Icon(Icons.add),
      ),

      //body=> stream builder
      body: StreamBuilder(
          stream: notesDatabase.stream,
          builder: (context, snapshot) {
            //loading
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            //loaded
            final notes = snapshot.data!;

            //list of notes UI
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                // list title UI
                return ListTile(
                  title: Text(note.content),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            updateNote(note);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteNote(note);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );

    //Button
  }
}
