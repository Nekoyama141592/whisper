import 'package:flutter/material.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';

import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/add_post/add_post_model.dart';

import 'package:whisper/components/add_post/components/add_post_screen/components/details/indicator.dart';

import 'package:whisper/components/add_post/components/audio_buttons/record_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/retry_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/arrow_forward_button.dart';
import 'package:whisper/details/rounded_input_field.dart';

import 'package:whisper/components/add_post/components/add_post_screen/components/details/recording_time.dart';
import 'package:whisper/components/add_post/audio_controll/audio_window.dart';

import 'package:whisper/components/add_post/components/notifiers/add_post_state_notifier.dart';

class AddPostContent extends StatelessWidget {

  AddPostContent(this.addPostModel,this.currentUserDoc);
  final AddPostModel addPostModel;
  final DocumentSnapshot currentUserDoc;
  @override
  Widget build(BuildContext context) {
    final postTitleController = TextEditingController(text: addPostModel.postTitleNotifier.value);
    final size = MediaQuery.of(context).size;
    return 
    ValueListenableBuilder<AddPostState>(
      valueListenable: addPostModel.addPostStateNotifier,
      builder: (_,value,__) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
            ),
            value == AddPostState.uploaded ?
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
              value!= AddPostState.recorded ?
              size.height * 0.4
              : size.height * 0.2,
            ),
            
            value == AddPostState.uploading ?
            Indicator()
            : value != AddPostState.recorded ?
            Column(
              children: [
                RecordButton(addPostModel),
              ],
            )
            
            : value != AddPostState.uploaded ?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RetryButton(addPostModel,'やりなおす'),
                ArrowForwardButton(addPostModel: addPostModel, currentUserDoc: currentUserDoc, text: '次へ')
              ],
            )
            : RetryButton(addPostModel,'次の投稿を行う'),
    
            RecordingTime(addPostModel,value != AddPostState.recorded ? 80 : 30),
    
            value == AddPostState.recorded ?
            Column(
              children: [
                RoundedInputField(
                  "Post title", 
                  Icons.graphic_eq, 
                  postTitleController, 
                  (text) {
                    addPostModel.postTitleNotifier.value = text;
                  }, 
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20
                  ),
                ),
                AudioWindow(addPostModel,currentUserDoc)
              ],
            ): SizedBox()
          ],
        );
      }
    );
  }
}