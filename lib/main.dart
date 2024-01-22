import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todofirebase/auth/authscreen.dart';
import 'package:todofirebase/screens/home.dart';
  // Import the opening page file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context,usersnapshot){

        if(usersnapshot.hasData){
          return Home();
        }
        else{
          return Authscreen();
        }
      },),
      debugShowCheckedModeBanner: false,

    );
  }
}
