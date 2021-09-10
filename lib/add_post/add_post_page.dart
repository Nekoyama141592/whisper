import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/parts/rounded_input_field.dart';
import 'add_post_model.dart';

import 'package:whisper/add_post/components/audio_buttons.dart';

class AddPostPage extends ConsumerWidget {

  AddPostPage(this.currentUserDoc);
  final DocumentSnapshot currentUserDoc;
  
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _addPostProvider = watch(addPostProvider);
    final postTitleController = TextEditingController();
    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _addPostProvider.isUploading ?
            Indicator()
            : AudioButtons(addPostProvider: _addPostProvider),
            RoundedInputField(
              "Post title", 
              Icons.graphic_eq, 
              postTitleController, 
              (text) {
                _addPostProvider.postTitle = text;
              }, 
              kPrimaryColor
            )
          ],
        ),
      ),
    );
  }
}

