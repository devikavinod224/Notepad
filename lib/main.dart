import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class Note {
  final String title;
  final String content;
  Note({required this.title, required this.content});
}

class NotesData extends ChangeNotifier {
  final List<Note> _notes = [];

  NotesData() {
    _notes.addAll([
      Note(title: 'Welcome', content: 'This is your first note!'),
      Note(title: 'notes List', content: 'python,java,c++'),
      Note(title: 'Important Task', content: 'complete a flutter tutorial'),
    ]);
  }

  List<Note> get notes => List.unmodifiable(_notes);

  void addNote(String title, String content) {
    if (title.isNotEmpty || content.isNotEmpty) {
      _notes.add(Note(title: title, content: content));
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotesData(),
      child: MaterialApp(
        title: 'Notes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample Notes')),
      body: Consumer<NotesData>(
        builder: (_, notesData, __) {
          if (notesData.notes.isEmpty) {
            return const Center(
              child:
                  Text('No notes yet. Add one!', style: TextStyle(fontSize: 18)),
            );
          }
          return ListView.builder(
            itemCount: notesData.notes.length,
            itemBuilder: (_, i) {
              final note = notesData.notes[i];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(note.content),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddNoteDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    final titleC = TextEditingController();
    final contentC = TextEditingController();

    showDialog(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('Add Note'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleC,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentC,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dCtx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<NotesData>(dCtx, listen: false)
                  .addNote(titleC.text.trim(), contentC.text.trim());
              Navigator.of(dCtx).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
