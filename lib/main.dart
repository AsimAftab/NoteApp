import 'package:flutter/material.dart';
import 'package:noteapp/screens/notes_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
 //sqfliteFfiInit();
 // databaseFactory=databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note X',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const NotesScreen(),
    );
  }
}

