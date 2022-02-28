import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/models/Note.dart';
import 'package:simple_notes/pages/notes_page.dart';
import 'package:simple_notes/services/auth_service.dart';
import 'package:simple_notes/services/note_service.dart';

class NoteDetailsPage extends StatefulWidget {
  final Note note;

  const NoteDetailsPage({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteDetailsPage> createState() => _NoteDetailsPageState(this.note);
}

class _NoteDetailsPageState extends State<NoteDetailsPage> {
  _NoteDetailsPageState(this.note);

  final Note note;
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleEditingController.text = note.title;
    _contentEditingController.text = note.content;
  }

  @override
  Widget build(BuildContext context) {
    NoteService notesService = NoteService(context.read<AuthService>().usuario);

    _handleSave() async {
      if (_titleEditingController.text.isNotEmpty &&
          _contentEditingController.text.isNotEmpty) {
        note.title = _titleEditingController.text;
        note.content = _contentEditingController.text;

        try {
          await notesService.updateNote(note);
        } on NoteException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message)));
          return;
        }

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => NotesPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Escreva um título e conteúdo para sua nota')));
      }
    }

    _handleDelete() async {
      try {
        await notesService.deleteNote(note.id);
      } on NoteException catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
        return;
      }

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => NotesPage()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Editar nota')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _titleEditingController,
                maxLines: 1,
                decoration: const InputDecoration.collapsed(hintText: "Título"),
              ),
            )),
            Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _contentEditingController,
                maxLines: 35,
                decoration: const InputDecoration.collapsed(hintText: "Nota"),
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.delete),
            onPressed: _handleDelete,
            backgroundColor: Colors.red,
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
              child: const Icon(Icons.save), onPressed: _handleSave),
        ],
      ),
    );
  }
}
