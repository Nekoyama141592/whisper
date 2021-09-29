import 'package:flutter/material.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/add_post/add_post_model.dart';

import 'package:whisper/components/add_post/components/add_post_screen/components/indicator.dart';

import 'package:whisper/components/add_post/components/audio_buttons/record_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/retry_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/upload_button.dart';

import 'package:whisper/details/rounded_input_field.dart';

import 'package:whisper/components/add_post/components/add_post_screen/components/recording_time.dart';
import 'package:whisper/components/add_post/audio_controll/audio_window.dart';


class AddPostContent extends StatelessWidget {

  AddPostContent(this.addPostProvider,this.currentUserDoc);
  final AddPostModel addPostProvider;
  final DocumentSnapshot currentUserDoc;
  @override
  Widget build(BuildContext context) {
    final postTitleController = TextEditingController(text: addPostProvider.postTitleNotifier.value);
    final size = MediaQuery.of(context).size;
    return 
    Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
        ),
        addPostProvider.addPostState == AddPostState.uploaded ?
        Padding(
          padding: const EdgeInsets.all(20),
          child: CustomSnackBar.success(
            message: '投稿、お疲れ様です！'
          ),
        )
        : 
        // SvgPicture
        SvgPicture.asset(
          'assets/svgs/recording-bro.svg',
          height: 
          addPostProvider.addPostState != AddPostState.recorded ?
          size.height * 0.4
          : size.height * 0.2,
        ),
        
        addPostProvider.addPostState == AddPostState.uploading ?
        Indicator()
        : addPostProvider.addPostState != AddPostState.recorded ?
        Column(
          children: [
            RecordButton(addPostProvider),
          ],
        )
        
        : addPostProvider.addPostState != AddPostState.uploaded ?
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RetryButton(addPostProvider,'やりなおす'),
            // UploadButton(addPostProvider)
          ],
        )
        : RetryButton(addPostProvider,'次の投稿を行う'),

        addPostProvider.addPostState != AddPostState.recorded ?
        RecordingTime(addPostProvider,80)
        : RecordingTime(addPostProvider,30),

        addPostProvider.addPostState == AddPostState.recorded ?
        Column(
          children: [
            RoundedInputField(
              "Post title", 
              Icons.graphic_eq, 
              postTitleController, 
              (text) {
                addPostProvider.postTitleNotifier.value = text;
              }, 
              kPrimaryColor
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20
              ),
            ),
            AudioWindow(addPostProvider,currentUserDoc)
          ],
        )
        : SizedBox()
      ],
    );
  }
}