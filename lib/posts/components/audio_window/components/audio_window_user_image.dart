// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
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
    return RedirectUserImage(userImageURL: whisperPost.userImageURL, length: defaultPadding(context: context) * 2.4, padding: defaultPadding(context: context),passiveUserDocId: whisperPost.uid,mainModel: mainModel,);
  }
}