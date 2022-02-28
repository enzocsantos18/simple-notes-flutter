import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/models/Note.dart';
import 'package:simple_notes/pages/note_create_page.dart';
import 'package:simple_notes/services/note_service.dart';

import '../services/auth_service.dart';
import '../widgets/note_list_item_widget.dart';

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NoteService notesService = NoteService(context.read<AuthService>().usuario);

    _handleCreateButton() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => NoteCreatePage()));
    }

    _handleLogout() async {
      await context.read<AuthService>().logout();
    }

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.logout),
          onTap: _handleLogout,
        ),
        title: const Text(
          'Notes',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(26.0),
          child: ValueListenableBuilder<List<Note>>(
            valueListenable: notesService.notes,
            builder: (_, notes, __) {
              return notes.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notes.length,
                      itemBuilder: (context, index) =>
                          NoteListItemWidget(note: notes[index]),
                      separatorBuilder: (_, __) => Divider(),
                    )
                  : const Text('Nenhuma nota cadastrada no momento ;)');
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleCreateButton,
        child: const Icon(Icons.add),
      ),
    );
  }
}
