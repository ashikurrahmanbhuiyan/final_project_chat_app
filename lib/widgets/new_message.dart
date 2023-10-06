import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  
  build(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 15 , right: 1 , bottom: 14),
      child: Row(children: [
        const Expanded(child: TextField(
        
        )),
        IconButton(
          color: Theme.of(context).colorScheme.primary,
          onPressed: (){}, 
          icon: const Icon(Icons.send))
      ],),
      );
  }
}