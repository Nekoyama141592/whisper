// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/upload_button.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';

class PickPostImagePage extends StatelessWidget {
  
  PickPostImagePage({
    Key? key,
    required this.addPostModel,
    required this.currentUserDoc
  }) : super(key: key);

  final AddPostModel addPostModel;
  final DocumentSnapshot currentUserDoc;
  
  @override 
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('image'),
      ),
      body: Center(
        child: ValueListenableBuilder<bool>(
          valueListenable: addPostModel.isCroppedNotifier,
          builder: (_,value,__) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.width * 0.6,
                  width: size.width * 0.6,
                  child: value ? Image.file(addPostModel.croppedFile!) : Image.network(currentUserDoc['imageURL']),
                ),
                RoundedButton(
                  value ? '写真を変更する' :'写真を追加(任意)', 
                  0.95, 
                  20, 
                  10, 
                  () async {
                    await addPostModel.showImagePicker();
                  }, 
                  Colors.white, 
                  value ? kTertiaryColor : kPrimaryColor
                ),
                UploadButton(addPostModel: addPostModel, currentUserDoc: currentUserDoc)
              ],
            );
          }
        ),
      ),
    );
  }
}