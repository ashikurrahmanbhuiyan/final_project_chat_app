import 'dart:io';

import 'package:final_project_chat_app/widgets/user_image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20,right: 35),
          
            child: ElevatedButton(
              onPressed: () async{
                await FirebaseAuth.instance.signOut();
              },
              child: const Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8,),
                      Text('Logout'),
                    ],
                  ),
            ),
          ) 
        ],
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Chat Screen'),
          ),
          UserImagePicker(
            onPickImage: (userImage) {
              //show image on screen
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  // ignore: unnecessary_null_comparison
                  foregroundImage: userImage!=null? FileImage(userImage):null,
                );
            }
          ),
        ],
      ),
      
    );
  }
}