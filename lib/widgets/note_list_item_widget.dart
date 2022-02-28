import 'package:flutter/material.dart';
import 'package:simple_notes/models/Note.dart';
import 'package:simple_notes/pages/note_details_page.dart';

class NoteListItemWidget extends StatelessWidget {
  const NoteListItemWidget({Key? key, required this.note}) : super(key: key);

  final Note note;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => NoteDetailsPage(note: note,), fullscreenDialog: true));
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.title, style: Theme.of(context).textTheme.titleLarge,),
              SizedBox(height: 10,),
              Text(
                  note.content),
            ],
          ),
        ),
      ),
    );
  }
}
