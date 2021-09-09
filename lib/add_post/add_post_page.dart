import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/parts/rounded_input_field.dart';
import 'add_post_model.dart';

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

class AudioButtons extends StatelessWidget {
  const AudioButtons({
    Key? key,
    required AddPostModel addPostProvider,
  }) : _addPostProvider = addPostProvider, super(key: key);

  final AddPostModel _addPostProvider;

  @override
  Widget build(BuildContext context) {
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AudioButton(
          'リトライ',
          Icon(Icons.replay),
          (){_addPostProvider.onRecordAgainButtonPressed();}
        ),

        AudioButton(
          '録音する',
          _addPostProvider.isLoading ?
          Icon(Icons.pause)
          : Icon(Icons.fiber_manual_record),
          () async {
            _addPostProvider.onRecordButtonPressed(context);
          }
        ),
        
        AudioButton(
          '公開する',
          Icon(Icons.upload_file),
          () async {
            await _addPostProvider.onAddButtonPressed(context);
          }
        )
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(),
        )
      ],
    );
  }
}

class AudioButton extends StatelessWidget {

  AudioButton(this.description,this.icon,this.press);
  final String description;
  final Widget icon;
  final void Function()? press;
  @override 
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          iconSize: 100,
          tooltip: description,
          icon: icon,
          onPressed: press, 
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10
          ),
          child: Text(description),
        )
      ],
    );
  }
}