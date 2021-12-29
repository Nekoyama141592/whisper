// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';

void addMutesUidAndMutesIpv6AndUid({ required List<dynamic> mutesUids, required List<dynamic> mutesIpv6AndUids, required Map<String,dynamic> map}) {
  final String uid = map['uid'];
  final String ipv6 = map['ipv6'];
  mutesUids.add(uid);
  mutesIpv6AndUids.add({
    'ipv6': ipv6,
    'uid': uid,
  });
}

Future<void> updateMutesIpv6AndUids({ required List<dynamic> mutesIpv6AndUids, required DocumentSnapshot currentUserDoc}) async {
  await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
  .update({
    'mutesIpv6AndUids': mutesIpv6AndUids,
  }); 
}

void addBlocksUidsAndBlocksIpv6AndUid({ required List<dynamic> blocksUids, required List<dynamic> blocksIpv6AndUids, required Map<String,dynamic> map }) {
  final String uid = map['uid'];
  final String ipv6 = map['ipv6'];
  blocksUids.add(uid);
  blocksIpv6AndUids.add({
    'ipv6': ipv6,
    'uid': uid,
  });
}

Future<void> updateBlocksIpv6AndUids({ required List<dynamic> blocksIpv6AndUids, required DocumentSnapshot currentUserDoc}) async {
  await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
  .update({
    'blocksIpv6AndUids': blocksIpv6AndUids,
  });
}

Future signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.pop(context);
  routes.toIsFinishedPage(context: context, title: 'ログアウトしました', text: 'お疲れ様でした');
}

void showCupertinoDialogue({required BuildContext context, required String title, required String content, required void Function()? action}) {
  showCupertinoDialog(context: context, builder: (context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: const Text('OK'),
          isDestructiveAction: true,
          onPressed: action,
        )
      ],
    );
  });
}

Future<void> play({ required AudioPlayer audioPlayer, required MainModel mainModel ,required String postId })  async {
    audioPlayer.play();
    if (!mainModel.readPostIds.contains(postId)) {
      final map = {
        'createdAt': Timestamp.now(),
        'durationInt': 0,
        'postId': postId,
      };
      
      mainModel.readPosts.add(map);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(mainModel.currentUserDoc.id)
      .update({
        'readPosts': mainModel.readPosts,
      });
    }
  }

void pause({ required AudioPlayer audioPlayer}) {
  audioPlayer.pause();
}

Future<void> onNotificationPressed({ required BuildContext context ,required MainModel mainModel , required Map<String,dynamic> notification, required OneCommentModel oneCommentModel, required OnePostModel onePostModel,required String giveCommentId, required String givePostId}) async {

  await mainModel.addNotificationIdToReadNotificationIds(notification: notification);
  // Plaase don`t notification['commentId'].
  // Please use commentNotification['commentId'], replyNotification['elementId']
  bool postExists = await onePostModel.init(givePostId: givePostId);
  if (postExists) {
    bool commentExists = await oneCommentModel.init(giveCommentId: giveCommentId);
    if (commentExists) {
      routes.toOneCommentPage(context: context, mainModel: mainModel);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('そのコメントは削除されています')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('元の投稿が削除されています')));
  }
}