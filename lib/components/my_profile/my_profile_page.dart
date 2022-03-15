
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

class MyProfilePage extends ConsumerWidget {

  const MyProfilePage({
    Key? key,
    required this.mainModel
  });

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProfileModel = ref.watch(myProfileProvider);
    final currentWhisperUser = mainModel.currentWhisperUser;

    return SafeArea(
      child: myProfileModel.isEditing ?
      EditProfileScreen(
        onCancelButtonPressed: () { myProfileModel.onCancelButtonPressed(); },
        onSaveButtonPressed: () async {
          await myProfileModel.onSaveButtonPressed(context: context, updateWhisperUser: mainModel.currentWhisperUser, mainModel: mainModel, );
        }, 
        showImagePicker: () async {
          await myProfileModel.showImagePicker();
        },
        onUserNameChanged: (text) {
          myProfileModel.userName = text;
        }, 
        bioController: TextEditingController(text:  currentWhisperUser.bio),
        userNameController: TextEditingController(text: currentWhisperUser.userName),
        croppedFile: myProfileModel.croppedFile,
        isLoading: myProfileModel.isLoading,
        isCropped: myProfileModel.isCropped,
        mainModel: mainModel,
      ) 
      : GradientScreen(
        top: SizedBox.shrink(), 
        header: UserShowHeader(
          onEditButtonPressed: () {
            myProfileModel.onEditButtonPressed();
          },
          passiveWhisperUser: mainModel.currentWhisperUser,
          backArrow: SizedBox.shrink(), 
          mainModel: mainModel, 
        ), 
        circular: MediaQuery.of(context).size.height/16.0,
        content: MyProfilePostScreen(myProfileModel: myProfileModel, mainModel: mainModel), 
      )
    );
  }
}