// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_svg/svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/components/add_post/components/audio_buttons/record_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/retry_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/arrow_forward_button.dart';
import 'package:whisper/components/add_post/components/add_post_content/components/indicator.dart';
import 'package:whisper/components/add_post/audio_controll/audio_window.dart';
import 'package:whisper/components/add_post/components/add_post_content/components/recording_time.dart';
// notifier
import 'package:whisper/components/add_post/components/notifiers/add_post_state_notifier.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';

class AddPostContent extends StatelessWidget {

  const AddPostContent({
    Key? key,
    required this.addPostModel,
    required this.currentUserDoc
  }) : super(key: key);

  final AddPostModel addPostModel;
  final DocumentSnapshot currentUserDoc;

  @override
  Widget build(BuildContext context) {
    final postTitleController = TextEditingController.fromValue(
      TextEditingValue(
        text: addPostModel.postTitleNotifier.value,
        selection: TextSelection.collapsed(
          offset: addPostModel.postTitleNotifier.value.length
        )
      )
    );
    final size = MediaQuery.of(context).size;
    return 
    ValueListenableBuilder<AddPostState>(
      valueListenable: addPostModel.addPostStateNotifier,
      builder: (_,value,__) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
              ),
              value == AddPostState.uploaded ?
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 25.0
                ),
                child: Text(
                  '投稿お疲れ様です！',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                )
              )
              : SizedBox.shrink(),
              // SvgPicture
              SvgPicture.asset(
                'assets/svgs/recording-bro.svg',
                height: 
                value != AddPostState.recorded && value != AddPostState.uploaded ?
                size.height * 0.4
                : size.height * 0.2,
              ),
              
              value == AddPostState.uploading ?
              Indicator()
              : value != AddPostState.recorded && value != AddPostState.uploaded ?
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
                    hintText: "タイトル", 
                    icon: Icons.graphic_eq, 
                    controller: postTitleController, 
                    onChanged:  (text) {
                      addPostModel.postTitleNotifier.value = text;
                    },
                    paste: (value) {
                      addPostModel.postTitleNotifier.value = value;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20
                    ),
                  ),
                  AudioWindow(addPostModel: addPostModel, currentUserDoc: currentUserDoc)
                ],
              ): SizedBox(),
              value == AddPostState.uploaded ?
              AudioWindow(addPostModel: addPostModel, currentUserDoc: currentUserDoc) : SizedBox.shrink()
            ],
          ),
        );
      }
    );
  }
}