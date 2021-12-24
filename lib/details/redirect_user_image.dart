// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'user_image.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';

class RedirectUserImage extends ConsumerWidget {
  
  const RedirectUserImage({
    Key? key,
    required this.userImageURL,
    required this.length,
    required this.padding,
    required this.passiveUserDocId,
    required this.mainModel,
  }) : super(key: key);

  final String userImageURL;
  final double length;
  final double padding;
  final String passiveUserDocId;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context,ScopedReader watch) {
    final userShowModel = watch(userShowProvider);
    return InkWell(
      onTap: () async {
        if (userShowModel.passiveUid != passiveUserDocId) {
          final DocumentSnapshot<Map<String, dynamic>> givePassiveUserDoc = await FirebaseFirestore.instance.collection('users').doc(passiveUserDocId).get();
          if (!givePassiveUserDoc.exists) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ユーザーが取得できませんでした')));
          } else {
            routes.toUserShowPage(context, givePassiveUserDoc, mainModel);
            await userShowModel.init(givePassiveUserDoc,mainModel.prefs);
          }
        } else {
          userShowModel.theSameUserIcon(context, mainModel);
        }
      },
      onLongPress: mainModel.currentUserDoc['isAdmin'] ? () async {
        await FlutterClipboard.copy(passiveUserDocId);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uidをコピーしました')));
      } : null,
      child: UserImage(padding: padding, length: length, userImageURL: userImageURL)
    );
  }
}