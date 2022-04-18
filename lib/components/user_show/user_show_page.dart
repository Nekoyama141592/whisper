// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/components/user_show/components/other_pages/post_search/post_search_model.dart';
// constants
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/components/user_show/components/details/user_show_header.dart';
import 'package:whisper/components/user_show/components/details/user_show_post_screen.dart';
import 'package:whisper/components/user_show/components/other_pages/edit_profile_screen.dart';
import 'package:whisper/details/loading.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';

class UserShowPage extends ConsumerWidget {
  
  const UserShowPage({
    Key? key,
    required this.mainModel
  });

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final userShowModel = ref.watch(userShowProvider);
    final PostSearchModel postSearchModel = ref.watch(postSearchProvider);
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: userShowModel.isLoading ?
      Loading() : 
      Container(
        child: userShowModel.isEditing ?
        SafeArea(
          child: EditProfileScreen(
            onCancelButtonPressed: () => userShowModel.onCancelButtonPressed(),
            onSaveButtonPressed: () async => await userShowModel.onSaveButtonPressed(context: context, updateWhisperUser: userShowModel.passiveWhisperUser, mainModel: mainModel,),
            showImagePicker: () async => await userShowModel.showImagePicker(),
            onUserNameChanged: (text) => userShowModel.userName = text,
            bioController: TextEditingController(text: userShowModel.passiveWhisperUser.bio ),
            userNameController: TextEditingController(text: userShowModel.passiveWhisperUser.userName ),
            croppedFile: userShowModel.croppedFile,
            isLoading: userShowModel.isLoading,
            isCropped: userShowModel.isCropped,
            mainModel: mainModel,
          )
        )
        : GradientScreen(
          top: SizedBox.shrink(), 
          header: UserShowHeader(
            onEditButtonPressed: () => userShowModel.onEditButtonPressed(),
            onMenuPressed: () =>userShowModel.onMenuPressed(context: context, mainModel: mainModel, postSearchModel: postSearchModel ),
            passiveWhisperUser: userShowModel.passiveWhisperUser,
            backArrow: InkWell(
              child: Icon(Icons.arrow_back),
              onTap: () => Navigator.pop(context),
            ),
            mainModel: mainModel, 
          ),
          content: UserShowPostScreen(userShowModel: userShowModel,mainModel: mainModel),
          circular: defaultPadding(context: context)
        ),
      )
    );
  }
}

