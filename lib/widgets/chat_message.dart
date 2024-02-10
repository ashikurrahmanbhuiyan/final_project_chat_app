import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_chat_app/widgets/message_bubble.dart';
import 'package:final_project_chat_app/widgets/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!chatSnapshot.hasData || chatSnapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("no message found"),
          );
        }

        if (chatSnapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        final loadedMessage = chatSnapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
          reverse: true,
          itemCount: loadedMessage.length,
          itemBuilder: (ctx, index) {
              final chatMessage = loadedMessage[index].data();
              final nextchatMessage = index +1 <loadedMessage
                  .length?loadedMessage[index+1].data():null;
              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId = nextchatMessage!=null 
                              ?nextchatMessage['userId']:null;
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;
              if(nextUserIsSame){
                return MessageBubble.next(
                  message: chatMessage['text'], 
                  isMe: authticatedUser.uid == currentMessageUserId
                  );
              }
              else{
                return MessageBubble.first(
                  userImage: chatMessage['userImage'], 
                  username: chatMessage['username'], 
                  message: chatMessage['text'], 
                  isMe: authticatedUser.uid == currentMessageUserId
                  );
              }

          }
        );
      },
    );
  }
}
