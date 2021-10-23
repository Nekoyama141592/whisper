// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/rounded_button.dart';

final searchCommentsProvider = ChangeNotifierProvider(
  (ref) => SearchCommentsModel()
);

class SearchCommentsModel extends ChangeNotifier {
  

  // comment
  String comment = "";
  Map<String,dynamic> postComment = {};
  // change
  List<dynamic> comments = [];
  bool didCommented = false;
  List<dynamic> postComments = [];
  // IP
  String ipv6 = '';

  void reload() {
    notifyListeners();
  }

  void sortCommentsByLikesUidsCount(List<dynamic> comments) {
    comments.sort((a,b) => b['likesUids'].length.compareTo(a['likesUids'].length ));
  }

  void onFloatingActionButtonPressed(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc) {
   final String commentsState = currentSongMap['commentsState'];
    final List<dynamic> followerUids = currentUserDoc['followerUids'];
    switch(commentsState){
      case 'open':
      showMakeCommentDialogue(context, currentSongMap, commentEditingController, currentUserDoc);
      break;
      case 'isLocked':
      if (currentSongMap['uid'] == currentUserDoc['uid']) {
        showMakeCommentDialogue(context, currentSongMap, commentEditingController, currentUserDoc);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('コメントは投稿主しかできません')));
      }
      break;
      case 'onlyFollowingUsers':
      if (followerUids.contains(currentSongMap['uid'])) {
        showMakeCommentDialogue(context, currentSongMap, commentEditingController, currentUserDoc);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('投稿主がフォローしている人しかコメントできません')));
      }
      break;
    }
  }

  void showMakeCommentDialogue(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc) {
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
            TextButton(
              child: Text(
                'cancel',
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
              onPressed: () { 
                Navigator.pop(context);
              },
            ),
            RoundedButton(
              text: '送信', 
              widthRate: 0.25, 
              verticalPadding: 10.0, 
              horizontalPadding: 0.0, 
              press: () async { 
                await makeComment(currentSongMap, currentUserDoc); 
                comment = '';
                Navigator.pop(context);
              }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).primaryColor
            )
          ],
        );
      }
    );
  }

  void showSortDialogue(BuildContext context,List<dynamic> thisComments) {
    showCupertinoDialog(
      context: context, 
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('並び替え',style: TextStyle(fontWeight: FontWeight.bold)),
          message: Text('コメントを並び替えます',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                sortCommentsByLikesUidsCount(thisComments);
              }, 
              child: Text(
                'いいね順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                thisComments.sort((a,b) => b['createdAt'].compareTo(a['createdAt']));
              }, 
              child: Text(
                '新しい順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                thisComments.sort((a,b) => a['createdAt'].compareTo(b['createdAt']));
              }, 
              child: Text(
                '古い順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
          ],
        );
      }
    );
  }

  Future makeComment(Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc) async {
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    makeCommentMap(currentUserDoc, currentSongMap);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongMap);
    await updateCommentsOfPostWhenMakeComment(newCurrentSongDoc);
    final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongMap);
    await updateCommentNotificationsOfPassiveUser(currentSongMap, currentUserDoc,passiveUserDoc);
  }

  void makeCommentMap(DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap) {
    final commentMap = {
      'comment': comment,
      'commentId': 'comment' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
      'createdAt': Timestamp.now(),
      'ipv6': ipv6,
      'likesUids': [],
      'score': 0,
      'uid': currentUserDoc['uid'],
      'userDocId': currentUserDoc.id,
      'userName': currentUserDoc['userName'],
      'userImageURL': currentUserDoc['imageURL'],
    };
    comments = currentSongMap['comments'];
    comments.add(commentMap);
    didCommented = true;
    notifyListeners();
  }


  Future updateCommentsOfPostWhenMakeComment(DocumentSnapshot newCurrentSongDoc) async {
    try{
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

    postComments = newCurrentSongDoc['comments'];
    //Likeが押された時のPost側の処理
    try{
      postComments.forEach((postComment) {
        if (postComment['commentId'] == commentId){
          // likesUids
          List<dynamic> likesUids = postComment['likesUids'];
          likesUids.add(currentUserDoc['uid']);
          FirebaseFirestore.instance
          .collection('posts')
          .doc(newCurrentSongDoc.id)
          .update({
            'comments': postComments,
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
    .doc(currentSongMap['objectID'])
    .get();
    return newCurrentSongDoc;
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
    postComments = newCurrentSongDoc['comments'];
    //Likeが押された時のPost側の処理
    try{
      postComments.forEach((postComment) {
        if (postComment['commentId'] == commentId){
          // likesUids
          List<dynamic> likesUids = postComment['likesUids'];
          likesUids.remove(currentUserDoc['uid']);
          FirebaseFirestore.instance
          .collection('posts')
          .doc(newCurrentSongDoc.id)
          .update({
            'comments': postComments,
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
    .doc(currentSongMap['objectID'])
    .update({
      'likedComments': likedComments,
    });
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