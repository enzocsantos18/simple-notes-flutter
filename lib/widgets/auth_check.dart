import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes/pages/login_page.dart';
import 'package:simple_notes/pages/notes_page.dart';
import 'package:simple_notes/services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    if (auth.isLoading)
      return CircularProgressIndicator();
    else if (auth.usuario == null) {
      print('dfdsfdsfds');
      return LoginPage();
    } else {
      print('logado');
      return NotesPage();
    }

  }
}
