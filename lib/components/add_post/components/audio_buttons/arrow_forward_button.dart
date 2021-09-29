import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';

import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/routes.dart' as routes;
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
        color: kTertiaryColor,
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