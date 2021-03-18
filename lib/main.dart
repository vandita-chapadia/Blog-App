import 'package:flutter/material.dart';
import 'LoginRegisterPage.dart';
import 'package:blogapp/HomePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:blogapp/Authentication.dart';
import 'Mapping.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(new BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Blog App",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
