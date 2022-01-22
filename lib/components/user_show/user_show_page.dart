// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/components/user_show/components/details/user_show_header.dart';
import 'package:whisper/components/user_show/components/details/user_show_post_screen.dart';
import 'package:whisper/components/user_show/components/other_pages/edit_profile_screen.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
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
  Widget build(BuildContext context, ScopedReader watch) {
    
    final userShowModel = watch(userShowProvider);
    List<dynamic> blocksIpv6AndUids = passiveWhisperUser.blocksIpv6AndUids;
    List<dynamic> passiveBlocksUids = [];
    blocksIpv6AndUids.forEach((blocksIpv6AndUid) {
      passiveBlocksUids.add(blocksIpv6AndUid[uidKey]);
    });

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: isDisplayShowPage(mutesUids: mainModel.mutesUids, blocksUids: mainModel.blocksUids, passiveBlocksUids: passiveBlocksUids, mainModel: mainModel ) ?
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
              await userShowModel.onSaveButtonPressed(context: context, mainModel: mainModel);
            },
            showImagePicker: () async { await userShowModel.showImagePicker(); },
            onUserNameChanged: (text) {
              userShowModel.userName = text;
            },
            onDescriptionChanged: (text) {
              userShowModel.description = text;
            },
            onLinkChanged: (text) {
              userShowModel.link = text;
            },
            croppedFile: userShowModel.croppedFile,
            isLoading: userShowModel.isLoading,
            isCropped: userShowModel.isCropped,
            mainModel: mainModel,
          )
        )
        : GradientScreen(
          top: SizedBox.shrink(), 
          header: UserShowHeader(
            onEditButtonPressed: () {
              userShowModel.onEditButtonPressed(mainModel: mainModel);
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

