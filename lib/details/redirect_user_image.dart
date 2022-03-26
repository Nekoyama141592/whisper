// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'user_image.dart';
// constants
import 'package:whisper/constants/strings.dart';
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
    required this.passiveUid,
    required this.mainModel,
  }) : super(key: key);

  final String userImageURL;
  final double length;
  final double padding;
  final String passiveUid;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final userShowModel = ref.watch(userShowProvider);
    return InkWell(
      onTap: () async {
        if (userShowModel.passiveUid != passiveUid) {
          final DocumentSnapshot<Map<String,dynamic>> givePassiveUserDoc = passiveUid == mainModel.currentWhisperUser.uid ? mainModel.currentUserDoc : await FirebaseFirestore.instance.collection(usersFieldKey).doc(passiveUid).get();
          if (givePassiveUserDoc.exists == false) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ユーザーが取得できませんでした')));
          } else {
            routes.toUserShowPage(context: context, mainModel: mainModel );
            await userShowModel.init( passiveUserDoc:givePassiveUserDoc,givePrefs: mainModel.prefs);
          }
        } else {
          userShowModel.theSameUser(context: context, mainModel: mainModel);
        }
      },
      onLongPress: () async {
        await FlutterClipboard.copy(passiveUid);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uidをコピーしました')));
      } ,
      child: UserImage(padding: padding, length: length, userImageURL: userImageURL,uid: passiveUid,mainModel: mainModel, )
    );
  }
}