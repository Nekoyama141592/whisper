// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/rounded_button.dart';
// states
import 'package:whisper/constants/states.dart';
// models
import 'package:whisper/main_model.dart';

final commentsProvider = ChangeNotifierProvider(
  (ref) => CommentsModel()
);

class CommentsModel extends ChangeNotifier {
  

  // comment
  String comment = "";
  Map<String,dynamic> postComment = {};
  // comments
  List<DocumentSnapshot> commentDocs = [];
  // IP
  String ipv6 = '';
  // refresh
  SortState sortState = SortState.byNewestFirst;
  late RefreshController refreshController;

  void reload() {
    notifyListeners();
  }

  Future<void> init(BuildContext context,AudioPlayer audioPlayer,ValueNotifier<Map<String,dynamic>> currentSongMapNotifier,MainModel mainModel,String postId) async {
    refreshController = RefreshController(initialRefresh: false);
    routes.toCommentsPage(context, audioPlayer, currentSongMapNotifier, mainModel);
    await getCommentDocs(postId);
  }

  Future<void> getCommentDocs(String postId) async {
    commentDocs = [];
    await FirebaseFirestore.instance.collection('comments').where('postId',isEqualTo: postId).orderBy('createdAt',descending: true).limit(oneTimeReadCount).get().then((qshot) {
      qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
    });
    notifyListeners();
  }

  void onFloatingActionButtonPressed(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc,AudioPlayer audioPlayer) {
    final String commentsState = currentSongMap['commentsState'];
    audioPlayer.pause();
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
            RoundedButton(
              text: '戻る', 
              widthRate: 0.25, 
              verticalPadding: 10.0, 
              horizontalPadding: 0.0, 
              press: () async { 
                Navigator.pop(context);
              }, 
              textColor: Theme.of(context).primaryColor, 
              buttonColor: Theme.of(context).focusColor
            ),
            RoundedButton(
              text: '送信', 
              widthRate: 0.25, 
              verticalPadding: 10.0, 
              horizontalPadding: 0.0, 
              press: () async { 
                await makeComment(context,currentSongMap, currentUserDoc); 
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

  
  Future makeComment(BuildContext context,Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc) async {
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final commentMap = makeCommentMap(currentUserDoc, currentSongMap);
    await FirebaseFirestore.instance.collection('comments').doc(commentMap['commentId']).set(commentMap);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('新しい順で上にスクロールするとあなたのコメントが新しく表示されます')));
    // notification
    if (currentSongMap['uid'] != currentUserDoc['uid']) {
      final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongMap);
      final List<dynamic> mutesUids = passiveUserDoc['mutesUids'];
      final List<dynamic> blockingUids = passiveUserDoc['blockingUids'];
      // mutesIpv6s
      List<dynamic> mutesIpv6s = [];
      final List<dynamic> mutesIpv6AndUids = passiveUserDoc['mutesIpv6AndUids'];
      mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
        mutesIpv6s.add(mutesIpv6AndUid['ipv6']);
      });
      if ( !mutesUids.contains(currentUserDoc['uid']) && !blockingUids.contains(currentUserDoc['uid']) && !mutesIpv6s.contains(currentUserDoc['uid']) ) {
        await updateCommentNotificationsOfPassiveUser(currentSongMap, currentUserDoc,passiveUserDoc);
      }
    }
  }


  Map<String,dynamic> makeCommentMap(DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap) {
    final commentMap = {
      'comment': comment,
      'commentId': 'comment' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
      'createdAt': Timestamp.now(),
      'followersCount': currentUserDoc['followersCount'],
      'ipv6': ipv6,
      'isNFTicon': currentUserDoc['isNFTicon'],
      'isOfficial': currentUserDoc['isOfficial'],
      'likesUids': [],
      'likesUidsCount': 0,
      'negativeScore': 0,
      'passiveUid': currentSongMap['uid'],
      'positiveScore': 0,
      'postId': currentSongMap['postId'],
      'replysCount': 0,
      'score': 10000,
      'uid': currentUserDoc['uid'],
      'userDocId': currentUserDoc.id,
      'userName': currentUserDoc['userName'],
      'userImageURL': currentUserDoc['imageURL'],
    };
    return commentMap;
  }

  Future updateCommentNotificationsOfPassiveUser(Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      List<dynamic> commentNotifications = passiveUserDoc['commentNotifications'];
      final Map<String,dynamic> newCommentNotificationMap = {
        'comment': comment,
        'createdAt': Timestamp.now(),
        'followersCount': currentUserDoc['followersCount'],
        'isNFTicon': currentUserDoc['isNFTicon'],
        'isOfficial': currentUserDoc['isOfficial'],
        'notificationId': 'commentNotification' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
        'passiveUid': currentSongMap['uid'],
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
  
  Future like(List<dynamic> likedCommentIds,DocumentSnapshot currentUserDoc,Map<String,dynamic> thisComment,List<dynamic> likedComments) async {
    final commentId = thisComment['commentId'];
    likedCommentIds.add(commentId);
    notifyListeners();
    final newCommentDoc = await setNewCommentDoc(thisComment);
    await updateLikesUidsOfComment(newCommentDoc, currentUserDoc);
    await updateLikedCommentsOfUser(commentId, likedComments, currentUserDoc);
  }

  Future updateLikesUidsOfComment(DocumentSnapshot newCommentDoc,DocumentSnapshot currentUserDoc) async {
    List<dynamic> likesUids = newCommentDoc['likesUids'];
    int likesUidsCount = newCommentDoc['likesUidsCount'];
    likesUids.add(currentUserDoc['uid']);
    notifyListeners();
    await FirebaseFirestore.instance.collection('comments').doc(newCommentDoc.id).update({
      'likesUids': likesUids,
      'likesUidsCount': likesUidsCount + 1,
    });
  }

  Future updateLikedCommentsOfUser(String commentId,List<dynamic> likedComments,DocumentSnapshot currentUserDoc) async {
    // User側の処理
    Map<String,dynamic> map = {
      'commentId': commentId,
      'createdAt': Timestamp.now(),
    };
    likedComments.add(map);
    await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
    .update({
      'likedComments': likedComments,
    });
  }

  Future unlike(List<dynamic> likedCommentIds,Map<String,dynamic> thisComment,DocumentSnapshot currentUserDoc,List<dynamic> likedComments) async {
    final commentId = thisComment['commentId'];
    likedCommentIds.remove(commentId);
    notifyListeners();
    final newCommentDoc = await setNewCommentDoc(thisComment);
    await removeLikesUidFromComment(newCommentDoc, currentUserDoc);
    await removeLikedCommentsFromCurrentUser(commentId, likedComments, currentUserDoc);
  }

  Future removeLikesUidFromComment(DocumentSnapshot newCommentDoc,DocumentSnapshot currentUserDoc) async {
    List<dynamic> likesUids = newCommentDoc['likesUids'];
    int likesUidsCount = newCommentDoc['likesUidsCount'];
    likesUids.remove(currentUserDoc['uid']);
    notifyListeners();
    await FirebaseFirestore.instance.collection('comments').doc(newCommentDoc.id).update({
      'likesUids': likesUids,
      'likesUidsCount': likesUidsCount - 1,
    });
  }

  Future removeLikedCommentsFromCurrentUser(String commentId,List<dynamic> likedComments,DocumentSnapshot currentUserDoc) async {
    likedComments.removeWhere((likedComment) => likedComment['commentId'] == commentId);
    await FirebaseFirestore.instance.collection('comments').doc(commentId).update({
      'likedComments': likedComments,
    });
  }

  Future setNewCommentDoc(Map<String,dynamic> thisComment) async {
    DocumentSnapshot newCommentDoc = await FirebaseFirestore.instance.collection('comments').doc(thisComment['commentId']).get();
    return newCommentDoc;
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

  void showSortDialogue(BuildContext context,Map<String,dynamic> currentSongMap) {
    showCupertinoDialog(
      context: context, 
      builder: (context) {
        final postId = currentSongMap['postId'];
        return CupertinoActionSheet(
          title: Text('並び替え',style: TextStyle(fontWeight: FontWeight.bold)),
          message: Text('コメントを並び替えます',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                commentDocs = [];
                sortState = SortState.byLikedUidsCount;
                await FirebaseFirestore.instance
                .collection('comments')
                .where('postId',isEqualTo: postId)
                .orderBy('likesUidsCount',descending: true )
                .limit(oneTimeReadCount)
                .get().then((qshot) {
                  qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
                });
                notifyListeners();
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
              onPressed: () async {
                Navigator.pop(context);
                commentDocs = [];
                sortState = SortState.byNewestFirst;
                await FirebaseFirestore.instance
                .collection('comments')
                .where('postId',isEqualTo: postId)
                .orderBy('createdAt',descending: true)
                .limit(oneTimeReadCount)
                .get().then((qshot) {
                  qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
                });
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
              onPressed: () async {
                Navigator.pop(context);
                commentDocs = [];
                sortState = SortState.byOldestFirst;
                await FirebaseFirestore.instance
                .collection('comments')
                .where('postId',isEqualTo: postId)
                .orderBy('createdAt',descending: false)
                .limit(oneTimeReadCount)
                .get().then((qshot) {
                  qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
                });
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

  Future<void> onRefresh(BuildContext context,Map<String,dynamic> currentSongMap) async {
    switch(sortState) {
      case SortState.byLikedUidsCount:
      break;
      case SortState.byNewestFirst:
      QuerySnapshot<Map<String, dynamic>> newSnapshots = await FirebaseFirestore.instance
      .collection('comments')
      .where('postId',isEqualTo: currentSongMap['postId'])
      .orderBy('createdAt',descending: true)
      .endBeforeDocument(commentDocs[0])
      .limit(oneTimeReadCount)
      .get();
      // Sort by oldest first
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
      docs.sort((a,b) => a['createdAt'].compareTo(b['createdAt']));
      // Insert at the top
      docs.forEach((doc) {
        commentDocs.insert(0, doc);
      });
      break;
      case SortState.byOldestFirst:
      break;
    }
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future<void> onLoading(Map<String,dynamic> currentSongMap) async {
    switch(sortState) {
      case SortState.byLikedUidsCount:
      await FirebaseFirestore.instance
      .collection('comments')
      .where('postId',isEqualTo: currentSongMap['postId'])
      .orderBy('likesUidsCount',descending: true )
      .startAfterDocument(commentDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { 
          commentDocs.add(doc); 
        });
      });
      break;
      case SortState.byNewestFirst:
      await FirebaseFirestore.instance
      .collection('comments')
      .where('postId',isEqualTo: currentSongMap['postId'])
      .orderBy('createdAt',descending: true)
      .startAfterDocument(commentDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
      });
      break;
      case SortState.byOldestFirst:
      await FirebaseFirestore.instance
      .collection('comments')
      .where('postId',isEqualTo: currentSongMap['postId'])
      .orderBy('createdAt',descending: false)
      .startAfterDocument(commentDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
      });
      break;
    }
    notifyListeners();
    refreshController.loadComplete();
  }
}