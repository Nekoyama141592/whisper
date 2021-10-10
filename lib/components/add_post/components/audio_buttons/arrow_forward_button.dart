// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/components/add_post/add_post_model.dart';
class ArrowForwardButton extends StatelessWidget {

  ArrowForwardButton({
    Key? key,
    required this.addPostModel,
    required this.currentUserDoc,
    required this.text,
    
  }) : super(key: key);
  final AddPostModel addPostModel;
  final DocumentSnapshot currentUserDoc;
  final String text;
  
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      text,
      Icon(
        Icons.arrow_forward,
        color: Theme.of(context).highlightColor,
      ),
      (){
        if (addPostModel.postTitleNotifier.value.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Post titleを入力してください')));
        } else {
          routes.toPickPostImagePage(context, addPostModel, currentUserDoc);
        }
      }
    );
  }
}