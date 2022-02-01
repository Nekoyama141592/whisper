
// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/components/user_show/components/details/user_show_header.dart';
import 'package:whisper/components/my_profile/components/my_profile_post_screen.dart';
import 'package:whisper/components/user_show/components/other_pages/edit_profile_screen.dart';
import 'package:whisper/links/links_model.dart';
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
    final linksModel = ref.watch(linksProvider);

    return SafeArea(
      child: myProfileModel.isEditing ?
      EditProfileScreen(
        onCancelButtonPressed: () { myProfileModel.onCancelButtonPressed(); },
        onSaveButtonPressed: () async {
          await myProfileModel.onSaveButtonPressed(context: context, mainModel: mainModel, links: linksModel.whisperLinks );
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
        croppedFile: myProfileModel.croppedFile,
        isLoading: myProfileModel.isLoading,
        isCropped: myProfileModel.isCropped,
        mainModel: mainModel,
        linksModel: linksModel,
      ) 
      : GradientScreen(
        top: SizedBox.shrink(), 
        header: UserShowHeader(
          onEditButtonPressed: () {
            myProfileModel.onEditButtonPressed(mainModel: mainModel);
          },
          passiveWhisperUser: mainModel.currentWhisperUser,
          backArrow: SizedBox.shrink(), 
          mainModel: mainModel, 
        ), 
        circular: 35.0,
        content: MyProfilePostScreen(myProfileModel: myProfileModel, mainModel: mainModel), 
      )
    );
  }
}