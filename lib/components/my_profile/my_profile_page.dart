
// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/components/user_show/components/details/user_show_header.dart';
import 'package:whisper/components/my_profile/components/my_profile_post_screen.dart';
import 'package:whisper/components/user_show/components/other_pages/edit_profile_screen.dart';
// models
import 'my_profile_model.dart';
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/components/follow/follow_model.dart';

class MyProfilePage extends ConsumerWidget {

  const MyProfilePage({
    Key? key,
    required this.mainModel
  });

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final myProfileModel = watch(myProfileProvider);
    final followModel = watch(followProvider);
    return SafeArea(
      child: myProfileModel.isEditing ?
      EditProfileScreen(
        onCancelButtonPressed: () { myProfileModel.onCancelButtonPressed(); },
        onSaveButtonPressed: () async {
          await myProfileModel.onSaveButtonPressed(context: context, mainModel: mainModel);
        }, 
        showImagePicker: () async {
          await myProfileModel.showImagePicker();
        }, 
        onUserNameChanged: (text) {
          myProfileModel.userName = text;
        }, 
        onDescriptionChanged: (text) {
          myProfileModel.description = text;
        }, 
        onLinkChanged: (text) {
          myProfileModel.link = text;
        }, 
        croppedFile: myProfileModel.croppedFile,
        isCropped: myProfileModel.isCropped,
        mainModel: mainModel
      ) 
      : GradientScreen(
        top: SizedBox.shrink(), 
        header: UserShowHeader(
          onEditButtonPressed: () {
            myProfileModel.onEditButtonPressed(mainModel.currentUserDoc);
          },
          passiveUserDoc: mainModel.currentUserDoc, 
          backArrow: SizedBox.shrink(), 
          mainModel: mainModel, 
          followModel: followModel
        ), 
        circular: 35.0,
        content: MyProfilePostScreen(myProfileModel: myProfileModel, mainModel: mainModel), 
      )
    );
  }
}