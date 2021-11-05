// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
// components
import 'package:whisper/details/rounded_button.dart';

final commentsProvider = ChangeNotifierProvider(
  (ref) => CommentsModel()
);

class CommentsModel extends ChangeNotifier {
  

  // comment
  String comment = "";
  Map<String,dynamic> postComment = {};
  // IP
  String ipv6 = '';

  void reload() {
    notifyListeners();
  }

 

  void onFloatingActionButtonPressed(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc,AudioPlayer audioPlayer,ValueNotifier<List<dynamic>> currentSongMapCommentsNotifier) {
    final String commentsState = currentSongMap['commentsState'];
    final List<dynamic> followerUids = currentUserDoc['followerUids'];
    audioPlayer.pause();
    switch(commentsState){
      case 'open':
      showMakeCommentDialogue(context, currentSongMap, commentEditingController, currentUserDoc,currentSongMapCommentsNotifier);
      break;
      case 'isLocked':
      if (currentSongMap['uid'] == currentUserDoc['uid']) {
        showMakeCommentDialogue(context, currentSongMap, commentEditingController, currentUserDoc,currentSongMapCommentsNotifier);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('コメントは投稿主しかできません')));
      }
      break;
      case 'onlyFollowingUsers':
      if (followerUids.contains(currentSongMap['uid'])) {
        showMakeCommentDialogue(context, currentSongMap, commentEditingController, currentUserDoc,currentSongMapCommentsNotifier);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('投稿主がフォローしている人しかコメントできません')));
      }
      break;
    }
  }

  void showMakeCommentDialogue(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc,ValueNotifier<List<dynamic>> currentSongMapCommentsNotifier) {
    showDialog(
      context: context, 
      builder: (_) {
        return AlertDialog(
          title: Text('comment'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                  child: TextField(
                    controller: commentEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      comment = text;
                    },
                  ),
                )
              ],
            ),
          ),
          actions: [
            RoundedButton(
              text: '送信', 
              widthRate: 0.25, 
              verticalPadding: 10.0, 
              horizontalPadding: 0.0, 
              press: () async { 
                // Navigator.pop(context);
                await makeComment(currentSongMap, currentUserDoc,currentSongMapCommentsNotifier); 
                comment = '';
              }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).primaryColor
            )
          ],
        );
      }
    );
  }

  
  Future makeComment(Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc,ValueNotifier<List<dynamic>> currentSongMapCommentsNotifier) async {
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final newCommentMap = makeCommentMap(currentUserDoc, currentSongMap,currentSongMapCommentsNotifier);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongMap);
    await updateCommentsOfPostWhenMakeComment(newCurrentSongDoc,newCommentMap);
    // notification
    if (currentSongMap['uid'] != currentUserDoc['uid']) {
      final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongMap);
      final List<dynamic> mutesUids = passiveUserDoc['mutesUids'];
      final List<dynamic> blockingUids = passiveUserDoc['blockingUids'];
      if (!mutesUids.contains(currentUserDoc['uid']) && blockingUids.contains(currentUserDoc['uid'])) {
        await updateCommentNotificationsOfPassiveUser(currentSongMap, currentUserDoc,passiveUserDoc);
      }
    }
  }

  Map<String,dynamic> makeCommentMap(DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap,ValueNotifier<List<dynamic>> currentSongMapCommentsNotifier) {
    final commentMap = {
      'comment': comment,
      'commentId': 'comment' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
      'createdAt': Timestamp.now(),
      'ipv6': ipv6,
      'isNFTicon': currentUserDoc['isNFTicon'],
      'isOfficial': currentUserDoc['isOfficial'],
      'likesUids': [],
      'score': 100,
      'uid': currentUserDoc['uid'],
      'userDocId': currentUserDoc.id,
      'userName': currentUserDoc['userName'],
      'userImageURL': currentUserDoc['imageURL'],
    };
    currentSongMapCommentsNotifier.value.add(commentMap);
    notifyListeners();
    return commentMap;
  }


  Future updateCommentsOfPostWhenMakeComment(DocumentSnapshot newCurrentSongDoc,Map<String,dynamic> newCommentMap) async {
    try{
      final List<dynamic> comments = newCurrentSongDoc['comments'];
      comments.add(newCommentMap);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(newCurrentSongDoc.id)
      .update({
        'comments': comments,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future updateCommentNotificationsOfPassiveUser(Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      List<dynamic> commentNotifications = passiveUserDoc['commentNotifications'];
      final Map<String,dynamic> newCommentNotificationMap = {
        'comment': comment,
        'createdAt': Timestamp.now(),
        'isNFTicon': currentUserDoc['isNFTicon'],
        'isOfficial': currentUserDoc['isOfficial'],
        'notificationId': 'commentNotification' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
        'postId': 'commentNotification' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
        'postTitle': currentSongMap['title'],
        'uid': currentUserDoc['uid'],
        'userDocId': currentUserDoc.id,
        'userName': currentUserDoc['userName'],
        'userImageURL': currentUserDoc['imageURL'],
      };
      commentNotifications.add(newCommentNotificationMap);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(passiveUserDoc.id)
      .update({
        'commentNotifications': commentNotifications,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future like(List<dynamic> likedCommentIds,DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap,String commentId,List<dynamic> likedComments) async {
    addCommentIdToLikedCommentIds(likedCommentIds, commentId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongMap);
    await updateCommentsOfPostWhenSomeoneLiked(newCurrentSongDoc, commentId, currentUserDoc);
    await updateLikedCommentsOfCurrentUser(commentId, likedComments, currentUserDoc);
  }
  
  void addCommentIdToLikedCommentIds(List<dynamic> likedCommentIds,String commentId) {
    likedCommentIds.add(commentId);
    notifyListeners();
  }

  Future updateCommentsOfPostWhenSomeoneLiked(DocumentSnapshot newCurrentSongDoc,String commentId,DocumentSnapshot currentUserDoc) async {

    final List<dynamic> comments = newCurrentSongDoc['comments'];
    //Likeが押された時のPost側の処理
    try{
      comments.forEach((postComment) {
        if (postComment['commentId'] == commentId){
          // likesUids
          List<dynamic> likesUids = postComment['likesUids'];
          likesUids.add(currentUserDoc['uid']);
          FirebaseFirestore.instance
          .collection('posts')
          .doc(newCurrentSongDoc.id)
          .update({
            'comments': comments,
          });
        }
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future updateLikedCommentsOfCurrentUser(String commentId,List<dynamic> likedComments,DocumentSnapshot currentUserDoc) async {
    // User側の処理
    Map<String,dynamic> map = {
      'commentId': commentId,
      'createdAt': Timestamp.now(),
    };

    likedComments.add(map);
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'likedComments': likedComments,
    });

  }

  Future unlike(List<dynamic> likedCommentIds,DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap,String commentId,List<dynamic> likedComments) async {
    removeCommentIdFromLikedCommentIds(likedCommentIds, commentId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongMap);
    await removeLikesUidFromComment(newCurrentSongDoc, currentUserDoc, commentId);
    await removeLikedCommentsFromCurrentUser(currentSongMap, commentId, likedComments);
  }

  void removeCommentIdFromLikedCommentIds(List<dynamic> likedCommentIds,String commentId) {
    likedCommentIds.remove(commentId);
    notifyListeners();
  }

  Future removeLikesUidFromComment(DocumentSnapshot newCurrentSongDoc,DocumentSnapshot currentUserDoc,String commentId) async {
    final List<dynamic> comments = newCurrentSongDoc['comments'];
    //Likeが押された時のPost側の処理
    try{
      comments.forEach((postComment) {
        if (postComment['commentId'] == commentId){
          // likesUids
          List<dynamic> likesUids = postComment['likesUids'];
          likesUids.remove(currentUserDoc['uid']);
          FirebaseFirestore.instance
          .collection('posts')
          .doc(newCurrentSongDoc.id)
          .update({
            'comments': comments,
          });
        }
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future removeLikedCommentsFromCurrentUser(Map<String,dynamic> currentSongMap,String commentId,List<dynamic> likedComments) async {
    likedComments.removeWhere((likedComment) => likedComment['commentId'] == commentId);
    await FirebaseFirestore.instance
    .collection('posts')
    .doc(currentSongMap['postId'])
    .update({
      'likedComments': likedComments,
    });
  }

  Future setPassiveUserDoc(Map<String,dynamic> currentSongMap) async {
    DocumentSnapshot passiveUserDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(currentSongMap['userDocId'])
    .get();
    return passiveUserDoc;
  }

  Future getNewCurrentSongDoc(Map<String,dynamic> currentSongMap) async {
    DocumentSnapshot newCurrentSongDoc = await FirebaseFirestore.instance
    .collection('posts')
    .doc(currentSongMap['postId'])
    .get();
    return newCurrentSongDoc;
  }

  Future updateCommentsOfPostWhenDelete(DocumentSnapshot newCurrentSongDoc,Map<String,dynamic> comment,String postDocId) async {
    final List<dynamic> newComments = newCurrentSongDoc['comments'];
    newComments.remove(comment);
    await FirebaseFirestore.instance
    .collection('posts')
    .doc(postDocId)
    .update({
      'comments': newComments,
    });
  }
}