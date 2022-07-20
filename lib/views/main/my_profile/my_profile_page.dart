
// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/models/post_search/post_search_model.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/views/main/user_show/components/user_show_header.dart';
import 'package:whisper/views/main/my_profile/components/my_profile_post_screen.dart';
import 'package:whisper/views/main/user_show/components/edit_profile_screen.dart';
// models
import '../../../models/main/my_profile_model.dart';
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
    final PostSearchModel postSearchModel = ref.watch(postSearchProvider);

    return SafeArea(
      child: myProfileModel.isEditing ?
      EditProfileScreen(
        onCancelButtonPressed: () => myProfileModel.onCancelButtonPressed(),
        onSaveButtonPressed: () async => await myProfileModel.onSaveButtonPressed(context: context, updateWhisperUser: mainModel.currentWhisperUser, mainModel: mainModel, ),
        showImagePicker: () async => await myProfileModel.showImagePicker(),
        onUserNameChanged: (text) => myProfileModel.userName = text,
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
          onEditButtonPressed: () => myProfileModel.onEditButtonPressed(),
          onMenuPressed: () { myProfileModel.onMenuPressed(context: context, mainModel: mainModel, postSearchModel: postSearchModel); },
          passiveWhisperUser: mainModel.currentWhisperUser,
          backArrow: SizedBox.shrink(), 
          mainModel: mainModel, 
        ), 
        circular: defaultPadding(context: context),
        content: MyProfilePostScreen(myProfileModel: myProfileModel, mainModel: mainModel), 
      )
    );
  }
}