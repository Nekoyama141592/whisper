import 'package:flutter/material.dart';


import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'package:whisper/constants/colors.dart';

import 'package:whisper/add_post/add_post_model.dart';
import 'package:whisper/add_post/components/indicator.dart';

import 'package:whisper/add_post/components/audio_buttons/retry_button.dart';
import 'package:whisper/add_post/components/audio_buttons/record_button.dart';
import 'package:whisper/add_post/components/audio_buttons/upload_button.dart';

import 'package:whisper/parts/components/rounded_input_field.dart';
import 'package:whisper/add_post/audio_controll/audio_window.dart';
class AddPostContent extends StatelessWidget {

  AddPostContent(this.addPostProvider,this.currentUserDoc);
  final AddPostModel addPostProvider;
  final DocumentSnapshot currentUserDoc;
  @override
  Widget build(BuildContext context) {
    final postTitleController = TextEditingController(text: addPostProvider.postTitle);
    final size = MediaQuery.of(context).size;
    return 
    InkWell(
      onTap: (){
        addPostProvider.reload();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          addPostProvider.isUploaded ?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomSnackBar.success(
              message: '投稿、お疲れ様です！'
            ),
          )
          : SizedBox(),
          SvgPicture.asset(
            'assets/svgs/recording-bro.svg',
            height: size.height * 0.3,
          ),
          addPostProvider.isUploading ?
          Indicator()
          : !addPostProvider.isRecorded ?
          RecordButton(addPostProvider)
          : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RetryButton(addPostProvider),
              UploadButton(addPostProvider)
            ],
          ),
          RoundedInputField(
            "Post title", 
            Icons.graphic_eq, 
            postTitleController, 
            (text) {
              addPostProvider.postTitle = text;
            }, 
            kPrimaryColor
          ),
          addPostProvider.isRecorded ?
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
          addPostProvider.isRecorded ?
          AudioWindow(addPostProvider,currentUserDoc)
          : SizedBox()
        ],
      ),
    );
  }
}