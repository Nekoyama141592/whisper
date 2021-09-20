import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/parts/components/rounded_input_field.dart';
import 'add_post_model.dart';

import 'package:whisper/add_post/components/audio_buttons.dart';
import 'package:whisper/add_post/audio_controll/audio_window.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class AddPostPage extends ConsumerWidget {

  AddPostPage(this.currentUserDoc);
  final DocumentSnapshot currentUserDoc;
  
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _addPostProvider = watch(addPostProvider);
    final postTitleController = TextEditingController(text: _addPostProvider.postTitle);
    return Scaffold(
      appBar: AppBar(
        title: Text('AddPost'),
      ),
      body: Center(
        child: InkWell(
          onTap: (){
            _addPostProvider.reload();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _addPostProvider.isUploaded ?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomSnackBar.success(
                  message: '投稿、お疲れ様です！'
                ),
              )
              : SizedBox(),
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
              ),
              
              _addPostProvider.isRecorded ?
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20
                ),
                child: Center(
                  child: Text(
                    '画面をタップすると名前の下のPost Titleが更新されます',
                  ),
                ),
              )
              : SizedBox(),
              _addPostProvider.isRecorded ?
              AudioWindow(_addPostProvider,currentUserDoc)
              : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

