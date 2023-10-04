import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatScreen extends StatelessWidget {
  const chatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: IconButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
              }, 
              icon: const Icon(Icons.logout),color: Theme.of(context).colorScheme.primary,),
          ) 
        ],
      ),
      body: const Center(
        child: Text('Chat Screen'),
      ),
    );
  }
}