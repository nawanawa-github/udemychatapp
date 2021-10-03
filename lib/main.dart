import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:udemychatapp/pages/top_page.dart';
import 'package:udemychatapp/utils/firebase.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Firestore.addUser();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TopPage(),
    );
  }
}
