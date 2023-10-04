import 'package:final_project_chat_app/chat.dart';
import 'package:final_project_chat_app/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Adda',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.brown,
        ).copyWith(
          secondary: const  Color.fromARGB(0, 0, 0, 0)
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const splashScreen();
          }
          if(snapshot.hasData){
            return const chatScreen();
          }
          return const AuthScreen();
        }
      ),

    );
  } 
}
