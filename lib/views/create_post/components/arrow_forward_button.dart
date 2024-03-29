// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/views/create_post/components/audio_button.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/create_post_model.dart';
class ArrowForwardButton extends StatelessWidget {

  ArrowForwardButton({
    Key? key,
    required this.addPostModel,
    required this.mainModel,
    required this.text,
    
  }) : super(key: key);
  final CreatePostModel addPostModel;
  final MainModel mainModel;
  final String text;
  
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      description: text,
      icon: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).highlightColor,
        size: addPostIconSize(context: context),
      ),
      press: () =>  addPostModel.postTitleNotifier.value.isEmpty ? 
        showBasicFlutterToast(context: context, msg: pleaseInputTitleMsg(context: context) ) : routes.toPickPostImagePage(context: context, addPostModel: addPostModel, mainModel: mainModel),
    );
  }
}