import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget{
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _entereduserName = '';
  File? _userImageFile;
  var _isUploading = false;

  void _submit() async{
    final  isValid = _formKey.currentState!.validate();
    if(!isValid && !_isLogin && _userImageFile == null) {
      return;
    }


    _formKey.currentState!.save ();
    
    try{
      setState(() {
        _isUploading = true;
      });

    if(_isLogin){
      await _firebase.signInWithEmailAndPassword(
        email: _enteredEmail, password: _enteredPassword);
        //print(userCredentials);
    }else{
      final userCredentials =  await _firebase.createUserWithEmailAndPassword(
        email: _enteredEmail, password: _enteredPassword);

        final strogeRef =  FirebaseStorage.instance.ref().child('user_dp')
        .child('${userCredentials.user!.uid}.jpg');

        await strogeRef.putFile(_userImageFile!);
        final imgUrl = await strogeRef.getDownloadURL();
        //print(imgUrl);

        await FirebaseFirestore.instance.collection('users')
        .doc(userCredentials.user!.uid).set({
          'username': _entereduserName,
          'email': _enteredEmail,
          'image_url': imgUrl,
        });
      }
    }on FirebaseAuthException catch(error){
      // if(error.code == 'email-alreay-in-use'){

      // }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          error.message ?? 'An error occurred, please check your credentials!')
          )
      );
      setState(() {
        _isUploading = false;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(margin: const EdgeInsets.only(top: 30,bottom: 20,left: 20,right: 20),
                width :200,
                child: Image.asset('assets/images/chat.png'),
                ),
                 Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(!_isLogin)
                           UserImagePicker(onPickImage: (userImage){
                            _userImageFile =  userImage;
                          },),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email Adress',
                          ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if(value ==null || value.trim().isEmpty || !value.contains('@')){
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onSaved: (value){
                              _enteredEmail = value!;
                            },
                        ),

                        TextFormField(
                            decoration: const InputDecoration(labelText: 'userName'),
                            enableSuggestions: false,
                            validator: (value){
                            if(value ==null || value.trim().isEmpty){
                                return 'Please enter a valid  username';
                              }
                              return null;
                            },
                          onSaved: (value){
                              _entereduserName = value!;
                          },
                        ),
                        if(!_isLogin)
                        TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty || value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                              onSaved: (value){
                              _enteredPassword = value!;
                            }
                          ),
                          const SizedBox(height: 12,),
                          if(_isUploading)
                            const CircularProgressIndicator(),
                          if(!_isUploading)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.onPrimary
                            ),
                            child: Text(_isLogin?'Login':'Signup'),
                          ),
                          if(!_isUploading)
                          TextButton(
                            onPressed: (){
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(_isLogin ? 'Create an account?' : 'I already have a account'),
                          )
                      ],
                    )),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
        );
  }
}