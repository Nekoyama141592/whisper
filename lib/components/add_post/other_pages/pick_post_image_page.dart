// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/upload_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/comments_state_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/add_link_button.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/add_post/add_post_model.dart';

class PickPostImagePage extends StatelessWidget {
  
  const PickPostImagePage({
    Key? key,
    required this.addPostModel,
    required this.mainModel
  }) : super(key: key);

  final AddPostModel addPostModel;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final length = size.width * 0.6;
    final L10n l10n = returnL10n(context: context)!;
    return Scaffold(
      appBar: AppBar(
        title: whiteBoldHeaderText(context: context,text: 'Image'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(defaultPadding(context: context))
          )
        ),
      ),
      body: Center(
        child: ValueListenableBuilder<bool>(
          valueListenable: addPostModel.isCroppedNotifier,
          builder: (_,value,__) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: length,
                    width: length,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).highlightColor
                      ),
                    ),
                    child: value ? Image.file(addPostModel.croppedFile!) : Image.network(mainModel.currentWhisperUser.userImageURL),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  RoundedButton(
                    text: value ? l10n.editImage : l10n.addImage, 
                    widthRate: 0.95,
                    fontSize: defaultHeaderTextSize(context: context),
                    press: () async => await addPostModel.showImagePicker(),
                    textColor: Colors.white, 
                    buttonColor: value ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.secondary
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CommentsStateButton(addPostModel: addPostModel),
                          AddLinkButton(addPostModel: addPostModel),
                        ],
                      ),
                      Center(child: UploadButton(addPostModel: addPostModel, mainModel: mainModel))
                    ],
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}