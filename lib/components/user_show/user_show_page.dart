// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
// components
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/components/user_show/components/details/user_show_header.dart';
import 'package:whisper/components/user_show/components/details/user_show_post_screen.dart';
import 'package:whisper/components/user_show/components/other_pages/edit_profile_screen.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/links/links_model.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';

class UserShowPage extends ConsumerWidget {
  
  const UserShowPage({
    Key? key,
    required this.passiveWhisperUser,
    required this.mainModel
  });

  final WhisperUser passiveWhisperUser;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final userShowModel = ref.watch(userShowProvider);
    final linksModel = ref.watch(linksProvider);

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: isDisplayShowPage(isBlocked: userShowModel.isBlocked, mainModel: mainModel) ?
      Column(
        children: [
            Text('コンテンツを表示できません',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),
            SizedBox(height: 20.0,),
            Text('あなたはこのユーザーをミュート、ブロック'),
            SizedBox(height: 20.0,),
            Text('もしくは相手にブロックされています')
        ],
      )
      : Container(
        child: userShowModel.isEditing ?
        SafeArea(
          child: EditProfileScreen(
            onCancelButtonPressed: () { userShowModel.onCancelButtonPressed(); },
            onSaveButtonPressed: () async {
              await userShowModel.onSaveButtonPressed(context: context, updateWhisperUser: passiveWhisperUser, mainModel: mainModel, links: linksModel.whisperLinks );
            },
            showImagePicker: () async { await userShowModel.showImagePicker(); },
            onUserNameChanged: (text) {
              userShowModel.userName = text;
            },
            onDescriptionChanged: (text) {
              userShowModel.description = text;
            },
            descriptionController: TextEditingController(text: passiveWhisperUser.description ),
            userNameController: TextEditingController(text: passiveWhisperUser.userName ),
            croppedFile: userShowModel.croppedFile,
            isLoading: userShowModel.isLoading,
            isCropped: userShowModel.isCropped,
            mainModel: mainModel,
            linksModel: linksModel,
          )
        )
        : GradientScreen(
          top: SizedBox.shrink(), 
          header: UserShowHeader(
            onEditButtonPressed: () {
              userShowModel.onEditButtonPressed();
            },
            passiveWhisperUser: passiveWhisperUser,
            backArrow: InkWell(
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            mainModel: mainModel, 
          ),
          content: UserShowPostScreen(userShowModel: userShowModel,mainModel: mainModel),
          circular: 35.0
        ),
      )
    );
  }
}

