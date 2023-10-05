import 'package:final_project_chat_app/chat.dart';
import 'package:final_project_chat_app/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'auth.dart'; 
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDu1g0zL6xF7-h7bCJItSqggMIHy8VvfNA', 
      appId: '1:905790811223::6cc80b4be0ec59f13f0712', 
      messagingSenderId: '905790811223', 
      projectId: 'flutter-chat-app-81e78',
      authDomain: 'flutter-chat-app-81e78.firebaseapp.com',
      storageBucket: 'flutter-chat-app-81e78.appspot.com',
      measurementId: 'G-S98XFHJ5BD',
      )
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
            return const SplashScreen();
          }

          if(snapshot.hasData){
            return const ChatScreen();
          }
          return const AuthScreen();
        }
      ),
    );
  } 
}
