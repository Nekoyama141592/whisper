// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_svg/svg.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/views/create_post/components/record_button.dart';
import 'package:whisper/views/create_post/components/retry_button.dart';
import 'package:whisper/views/create_post/components/arrow_forward_button.dart';
import 'package:whisper/views/create_post/create_post_content/components/indicator.dart';
import 'package:whisper/l10n/l10n.dart';
import 'package:whisper/posts/components/one_post_audio_window/one_post_audio_window.dart';
import 'package:whisper/views/create_post/create_post_content/components/recording_time.dart';
// notifier
import 'package:whisper/notifiers/create_post_state_notifier.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/create_post_model.dart';

class CreatePostContent extends StatelessWidget {

  const CreatePostContent({
    Key? key,
    required this.addPostModel,
    required this.mainModel,
  }) : super(key: key);

  final CreatePostModel addPostModel;
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
    final L10n l10n = returnL10n(context: context)!;
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
    ValueListenableBuilder<CreatePostState>(
      valueListenable: addPostModel.addPostStateNotifier,
      builder: (_,value,__) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
              ),
              value == CreatePostState.uploaded ?
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: height/75.0
                ),
                child: Text(
                  l10n.thanksForPosting,
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
                  value != CreatePostState.recorded && value != CreatePostState.uploaded ?
                  size.height * 0.4
                  : size.height * 0.2,
                ),
              ),
              
              value == CreatePostState.uploading ?
              Indicator()
              : value != CreatePostState.recorded && value != CreatePostState.uploaded ?
              Column(
                children: [
                  RecordButton(mainModel: mainModel, addPostModel: addPostModel)
                ],
              )
              
              : value != CreatePostState.uploaded ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RetryButton(addPostModel: addPostModel, text: l10n.reset ),
                  ArrowForwardButton(addPostModel: addPostModel, mainModel: mainModel, text: l10n.next )
                ],
              )
              : RetryButton(addPostModel: addPostModel, text: l10n.nextPost),
              RecordingTime(addPostModel: addPostModel, fontSize: value != CreatePostState.recorded ? height/12.0 : height/24.0),
            
              value == CreatePostState.recorded ?
              Column(
                children: [
                  RoundedInputField(
                    hintText: l10n.title, 
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
              value == CreatePostState.uploaded ?
              onePostAudioWindow : SizedBox.shrink()
            ],
          ),
        );
      }
    );
  }
}