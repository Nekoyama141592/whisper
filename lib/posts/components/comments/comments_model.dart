// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/rounded_button.dart';

final commentsProvider = ChangeNotifierProvider(
  (ref) => CommentsModel()
);

class CommentsModel extends ChangeNotifier {
  

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

  void sortCommentsByLikesUidsCount(List<dynamic> thisComments) {
    comments.sort((a,b) => b['likesUids'].length.compareTo(a['likesUids'].length ));
  }

  void onFloatingActionButtonPressed(BuildContext context,DocumentSnapshot currentSongDoc,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc) {
    final String commentsState = currentSongDoc['commentsState'];
    final List<dynamic> followerUids = currentUserDoc['followerUids'];
    switch(commentsState){
      case 'open':
      showMakeCommentDialogue(context, currentSongDoc, commentEditingController, currentUserDoc);
      break;
      case 'isLocked':
      if (currentSongDoc['uid'] == currentUserDoc['uid']) {
        showMakeCommentDialogue(context, currentSongDoc, commentEditingController, currentUserDoc);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('コメントは投稿主しかできません')));
      }
      break;
      case 'onlyFollowingUsers':
      if (followerUids.contains(currentSongDoc['uid'])) {
        showMakeCommentDialogue(context, currentSongDoc, commentEditingController, currentUserDoc);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('投稿主がフォローしている人しかコメントできません')));
      }
      break;
    }
  }

  void showMakeCommentDialogue(BuildContext context,DocumentSnapshot currentSongDoc,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc) {
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
                await makeComment(currentSongDoc, currentUserDoc); 
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
                Navigator.pop(context);
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
                Navigator.pop(context);
                thisComments.sort((a,b) => b['createdAt'].compareTo(a['createdAt']));
                notifyListeners();
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
                Navigator.pop(context);
                thisComments.sort((a,b) => a['createdAt'].compareTo(b['createdAt']));
                notifyListeners();
              }, 
              child: Text(
                '古い順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: Text(
                'キャンセル',
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

  Future makeComment(DocumentSnapshot currentSongDoc,DocumentSnapshot currentUserDoc) async {
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    makeCommentMap(currentUserDoc, currentSongDoc);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await updateCommentsOfPostWhenMakeComment(newCurrentSongDoc);
    final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongDoc);
    await updateCommentNotificationsOfPassiveUser(currentSongDoc, currentUserDoc,passiveUserDoc);
  }

  void makeCommentMap(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc) {
    final commentMap = {
      'comment': comment,
      'commentId': 'comment' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
      'createdAt': Timestamp.now(),
      'ipv6': ipv6,
      'isNFTicon': false,
      'isOfficial': false,
      'likesUids': [],
      'score': 0,
      'uid': currentUserDoc['uid'],
      'userDocId': currentUserDoc.id,
      'userName': currentUserDoc['userName'],
      'userImageURL': currentUserDoc['imageURL'],
    };
    comments = currentSongDoc['comments'];
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

  Future updateCommentNotificationsOfPassiveUser(DocumentSnapshot currentSongDoc,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      List<dynamic> commentNotifications = passiveUserDoc['commentNotifications'];
      final Map<String,dynamic> newCommentNotificationMap = {
        'comment': comment,
        'createdAt': Timestamp.now(),
        'notificationId': 'commentNotification' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
        'postId': 'commentNotification' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
        'postTitle': currentSongDoc['title'],
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

  Future like(List<dynamic> likedCommentIds,DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,String commentId,List<dynamic> likedComments) async {
    addCommentIdToLikedCommentIds(likedCommentIds, commentId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
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

  Future unlike(List<dynamic> likedCommentIds,DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,String commentId,List<dynamic> likedComments) async {
    removeCommentIdFromLikedCommentIds(likedCommentIds, commentId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await removeLikesUidFromComment(newCurrentSongDoc, currentUserDoc, commentId);
    await removeLikedCommentsFromCurrentUser(currentSongDoc, commentId, likedComments);
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

  Future removeLikedCommentsFromCurrentUser(DocumentSnapshot currentSongDoc,String commentId,List<dynamic> likedComments) async {
    likedComments.removeWhere((likedComment) => likedComment['commentId'] == commentId);
    await FirebaseFirestore.instance
    .collection('posts')
    .doc(currentSongDoc.id)
    .update({
      'likedComments': likedComments,
    });
  }

  Future setPassiveUserDoc(DocumentSnapshot currentSongDoc) async {
    DocumentSnapshot passiveUserDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(currentSongDoc['userDocId'])
    .get();
    return passiveUserDoc;
  }

  Future getNewCurrentSongDoc(DocumentSnapshot currentSongDoc) async {
    DocumentSnapshot newCurrentSongDoc = await FirebaseFirestore.instance
    .collection('posts')
    .doc(currentSongDoc.id)
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