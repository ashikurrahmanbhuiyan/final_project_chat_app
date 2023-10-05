import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget{
  const UserImagePicker({Key? key}) : super(key: key);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;
  void _pickImage() async {
    final pickImage =  await ImagePicker().pickImage(source: ImageSource.camera,  imageQuality: 50, maxWidth: 150);
  
    if(pickImage == null){return;} 

    setState(() {
      _pickedImageFile = File(pickImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey,
        foregroundImage: _pickedImageFile!=null? FileImage(_pickedImageFile!):null,
      ),
      TextButton.icon(
        onPressed: _pickImage, 
        icon: const Icon(Icons.image), 
        label: Text('Add Image',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          )
          )
    ]);
  }
}