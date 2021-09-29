import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'add_post_model.dart';
import 'package:whisper/components/add_post/components/add_post_screen/add_post_screen.dart';
import 'package:whisper/components/add_post/components/add_post_screen/components/add_post_content.dart';

class AddPostPage extends StatelessWidget {

  AddPostPage({
    Key? key,
    required this.currentUserDoc,
    required this.addPostModel
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final AddPostModel addPostModel;
  
  @override  
  Widget build(BuildContext context) {
    return AddPostScreen(
      content: AddPostContent(addPostModel, currentUserDoc),
       addPostModel: addPostModel, 
       currentUserDoc: currentUserDoc
      );
  }
}

