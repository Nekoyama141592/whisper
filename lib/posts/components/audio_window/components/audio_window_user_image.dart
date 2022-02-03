// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';

class AudioWindowUserImage extends StatelessWidget {

  const AudioWindowUserImage({
    Key? key,
    required this.whisperPost,
    required this.mainModel
  }) : super(key: key);
  
  final Post whisperPost;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context) {
    return RedirectUserImage(userImageURL: whisperPost.userImageURL, length: 40.0, padding: 5.0,passiveUserDocId: whisperPost.uid,mainModel: mainModel,);
  }
}