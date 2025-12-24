import 'package:civic_issue_reporter/main.dart';
import 'package:civic_issue_reporter/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    // return either Home or Authenticate widget
    if (user == null){
      return const AuthScreen();
    } else {
      return const MainScreen();
    }
  }
}
