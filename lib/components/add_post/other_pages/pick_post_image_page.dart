// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/upload_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/comments_state_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/add_link_button.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('image'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16.0)
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
                    height: size.width * 0.6,
                    width: size.width * 0.6,
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
                    text: value ? '写真を変更する' :'写真を追加(任意)', 
                    widthRate: 0.95,
                    fontSize: defaultHeaderTextSize(context: context),
                    press: () async {
                      await addPostModel.showImagePicker();
                    }, 
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