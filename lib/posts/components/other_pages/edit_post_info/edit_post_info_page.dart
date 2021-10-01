// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/rounded_button.dart';
// model
import 'edit_post_info_model.dart';

class EditPostInfoPage extends ConsumerWidget {

  const EditPostInfoPage({
    Key? key,
    required this.postTitle,
    required this.currentUserDoc,
    required this.songDocId,
    required this.imageURL,
  }) : super(key: key);

  final String postTitle;
  final DocumentSnapshot currentUserDoc;
  final String songDocId;
  final String imageURL;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {

    final size = MediaQuery.of(context).size;
    final length = size.width * 0.8;
    final editPostInfoModel = watch(editPostInfoProvider);
    final postTitleController = TextEditingController(
      text: editPostInfoModel.isEdited ? editPostInfoModel.postTitle : postTitle
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 25
                      ),
                    ),
                  ),
                  SizedBox(width: size.width * 0.4,),
                  RoundedButton(
                    '保存', 
                    0.25, 
                    10, 
                    5, 
                    () async  {
                      await editPostInfoModel.updatePostInfo(songDocId,currentUserDoc['uid']);
                    },
                    Colors.white, 
                    Theme.of(context).highlightColor
                  )
                ],
              ),
              !editPostInfoModel.isCropped ?
              Container(
                width: length,
                height: length,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).highlightColor
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(imageURL),
                  )
                ),
              ) 
              : SizedBox(width: length,height: length,child: Image.file(editPostInfoModel.croppedFile!)),
              RoundedButton(
                editPostInfoModel.isCropped ? '写真を変更する' :'投稿用の写真を編集',
                0.95, 
                20, 
                10, 
                () async {
                  await editPostInfoModel.showImagePicker();
                }, 
                Colors.white, 
                editPostInfoModel.isCropped ?  Theme.of(context).primaryColor : Theme.of(context).highlightColor
              ),
              Text('タイトル'),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: postTitleController,
                onChanged: (text) {
                  editPostInfoModel.postTitle = text;
                },
              )
            ]
          ),
        ),
      ),
    );
  }
}