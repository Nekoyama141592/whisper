// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_svg/svg.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/components/add_post/components/audio_buttons/record_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/retry_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/arrow_forward_button.dart';
import 'package:whisper/components/add_post/components/add_post_content/components/indicator.dart';
import 'package:whisper/posts/components/one_post_audio_window/one_post_audio_window.dart';
import 'package:whisper/components/add_post/components/add_post_content/components/recording_time.dart';
// notifier
import 'package:whisper/components/add_post/components/notifiers/add_post_state_notifier.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/add_post/add_post_model.dart';

class AddPostContent extends StatelessWidget {

  const AddPostContent({
    Key? key,
    required this.addPostModel,
    required this.mainModel,
  }) : super(key: key);

  final AddPostModel addPostModel;
  final MainModel mainModel;

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
    final height = size.height;

    final Widget onePostAudioWindow = OnePostAudioWindow(
      route: null,
      progressNotifier: addPostModel.progressNotifier, 
      playButtonNotifier: addPostModel.playButtonNotifier, 
      seek: addPostModel.seek, 
      play: () => addPostModel.play(),
      pause: () => addPostModel.pause(),
      title: ValueListenableBuilder<String>(
        valueListenable: addPostModel.postTitleNotifier,
        builder: (_,postTitle,__) {
          return 
          Text(
            postTitle,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2
            ),
          );
        }
      ),
      mainModel: mainModel,
    );
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
                padding: EdgeInsets.symmetric(
                  vertical: height/75.0
                ),
                child: Text(
                  '投稿お疲れ様です！',
                  style: TextStyle(
                    fontSize: height/30.0,
                    fontWeight: FontWeight.bold
                  ),
                )
              )
              : SizedBox.shrink(),
              // SvgPicture
              Padding(
                padding: EdgeInsets.all(height/75.0),
                child: SvgPicture.asset(
                  'assets/svgs/recording-bro.svg',
                  height: 
                  value != AddPostState.recorded && value != AddPostState.uploaded ?
                  size.height * 0.4
                  : size.height * 0.2,
                ),
              ),
              
              value == AddPostState.uploading ?
              Indicator()
              : value != AddPostState.recorded && value != AddPostState.uploaded ?
              Column(
                children: [
                  RecordButton(mainModel: mainModel, addPostModel: addPostModel)
                ],
              )
              
              : value != AddPostState.uploaded ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RetryButton(addPostModel,'やりなおす'),
                  ArrowForwardButton(addPostModel: addPostModel, mainModel: mainModel, text: '次へ')
                ],
              )
              : RetryButton(addPostModel,'次の投稿を行う'),
              RecordingTime(addPostModel,value != AddPostState.recorded ? height/12.0 : height/24.0 ),
            
              value == AddPostState.recorded ?
              Column(
                children: [
                  RoundedInputField(
                    hintText: "タイトル", 
                    icon: Icons.graphic_eq, 
                    controller: postTitleController, 
                    onChanged:  (text) => addPostModel.postTitleNotifier.value = text,
                    onCloseButtonPressed: () {
                      postTitleController.text = '';
                      addPostModel.postTitleNotifier.value = '';
                    },
                    paste: (value) => addPostModel.postTitleNotifier.value = value,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height/75.0
                    ),
                  ),
                  onePostAudioWindow
                ],
              ): SizedBox(),
              value == AddPostState.uploaded ?
              onePostAudioWindow : SizedBox.shrink()
            ],
          ),
        );
      }
    );
  }
}