import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/pages/notes_page.dart';
import 'package:simple_notes/services/note_service.dart';

import '../services/auth_service.dart';

class NoteCreatePage extends StatefulWidget {
  const NoteCreatePage({Key? key}) : super(key: key);

  @override
  State<NoteCreatePage> createState() => _NoteCreatePageState();
}

class _NoteCreatePageState extends State<NoteCreatePage> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    NoteService notesService = NoteService(context.read<AuthService>().usuario);

    _handleSave() async {
      if (_titleEditingController.text.isNotEmpty &&
          _contentEditingController.text.isNotEmpty) {
        try {
          await notesService.createNote(
              _titleEditingController.text, _contentEditingController.text);
        } on NoteException catch (e) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.message)));
          return;
        }

        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => NotesPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Escreve um título e conteúdo para sua nota')));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Criar nota')),
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
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.save), onPressed: _handleSave),
    );
  }
}
