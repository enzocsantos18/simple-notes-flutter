import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:simple_notes/models/Note.dart';

class NoteService {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ValueNotifier<List<Note>> notes = ValueNotifier<List<Note>>(List.empty());

  late User? user;

  NoteService(this.user) {
    getNotes();
  }

  getNotes() async {
    try {
      QuerySnapshot querySnapshot = await firebaseFirestore
          .collection('notes')
          .where('userId', isEqualTo: this.user?.uid.toString())
          .get();

      notes.value = querySnapshot.docs
          .map((doc) => Note(
              id: doc.id, title: doc.get("title"), content: doc.get("content")))
          .toList();
    } on Exception catch (e) {
      throw NoteException("Erro ao buscar notas");
    }
  }

  createNote(String title, String content) async {
    try {
      await firebaseFirestore.collection('notes').add({
        'title': title,
        'content': content,
        'userId': this.user?.uid.toString()
      });
    } on Exception catch (e) {
      throw NoteException("Erro ao criar uma nota, tente novamente mais tarde");
    }
  }

  updateNote(Note note) async {
    try {
      await firebaseFirestore
          .collection('notes')
          .doc(note.id)
          .update({'title': note.title, 'content': note.content});
    } on Exception catch (e) {
      throw NoteException(
          "Erro ao atualizar uma nota, tente novamente mais tarde");
    }
  }

  deleteNote(String noteId) async {
    try {
      await firebaseFirestore.collection('notes').doc(noteId).delete();
    } on Exception catch (e) {
      throw NoteException(
          "Erro ao deletar uma nota, tente novamente mais tarde");
    }
  }
}

class NoteException implements Exception {
  String message;

  NoteException(this.message);
}
