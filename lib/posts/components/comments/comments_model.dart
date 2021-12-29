// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/routes.dart' as routes;
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
  // DB index
  String indexPostId = '';

  int commentScrollFlashBarCount = 0;

  void reload() {
    notifyListeners();
  }

  Future<void> init(BuildContext context,AudioPlayer audioPlayer,ValueNotifier<Map<String,dynamic>> currentSongMapNotifier,MainModel mainModel,String postId) async {
    refreshController = RefreshController(initialRefresh: false);
    routes.toCommentsPage(context, audioPlayer, currentSongMapNotifier, mainModel);
    if (indexPostId != postId) {
      indexPostId = postId;
      await getCommentDocs(postId);
    }
  }

  Future<void> getCommentDocs(String postId) async {
    commentDocs = [];
    await FirebaseFirestore.instance.collection('comments').where('postId',isEqualTo: postId).orderBy('createdAt',descending: true).limit(oneTimeReadCount).get().then((qshot) {
      qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
    });
    notifyListeners();
  }

  void onFloatingActionButtonPressed(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc,AudioPlayer audioPlayer,{ required SharedPreferences prefs}) {
    final String commentsState = currentSongMap['commentsState'];
    audioPlayer.pause();
    switch(commentsState){
      case 'open':
      showMakeCommentInputFlashBar(context, currentSongMap, commentEditingController, currentUserDoc,prefs: prefs);
      break;
      case 'isLocked':
      if (currentSongMap['uid'] == currentUserDoc['uid']) {
        showMakeCommentInputFlashBar(context, currentSongMap, commentEditingController, currentUserDoc,prefs: prefs);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('コメントは投稿主しかできません')));
      }
      break;
    }
  }

  void showMakeCommentInputFlashBar(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc ,{ required SharedPreferences prefs}) {
    
    context.showFlashBar(
      persistent: true,
      borderWidth: 3.0,
      behavior: FlashBehavior.fixed,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: Row(
        children: [
          Text('コメントを入力'),
        ],
      ),
      content: Form(
        child: TextFormField(
          controller: commentEditingController,
          autofocus: true,
          style: TextStyle(fontWeight: FontWeight.bold),
          onChanged: (text) {
            comment = text;
          },
        )
      ),
      primaryActionBuilder: (context, controller, _) {
        return IconButton(
          onPressed: () async {
            if (commentEditingController.text.isEmpty) {
              controller.dismiss();
            } else {
              await makeComment(context, currentSongMap, currentUserDoc,prefs);
              comment = '';
              controller.dismiss();
            }
          },
          icon: Icon(Icons.send, color: Theme.of(context).primaryColor ),
        );
      },
      negativeActionBuilder: (context,controller,__) {
        return InkWell(
          child: Icon(Icons.close),
          onTap: () {
            controller.dismiss();
          },
        );
      }
    );
  }

  
  Future makeComment(BuildContext context,Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc,SharedPreferences prefs) async {
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final commentMap = makeCommentMap(currentUserDoc, currentSongMap);
    await FirebaseFirestore.instance.collection('comments').doc(commentMap['commentId']).set(commentMap);
    commentScrollFlashBarCount = prefs.getInt('commentScrollFlashBarCount') ?? 0;
    if (commentScrollFlashBarCount <= commentScrollFlashBarConstantCount) {
      showTopFlash(context);
    }
    // notification
    if (currentSongMap['uid'] != currentUserDoc['uid']) {
      final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongMap);
      // blocks
      List<dynamic> blocksIpv6s = [];
      List<dynamic> blocksUids = [];
      final List<dynamic> blocksIpv6AndUids = passiveUserDoc['blocksIpv6AndUids'];
      blocksIpv6AndUids.forEach((blocksIpv6AndUid) {
        blocksIpv6s.add(blocksIpv6AndUid['ipv6']);
        blocksUids.add(blocksIpv6AndUid['uid']);
      });
      // mutes
      List<dynamic> mutesUids = [];
      List<dynamic> mutesIpv6s = [];
      final List<dynamic> mutesIpv6AndUids = passiveUserDoc['mutesIpv6AndUids'];
      mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
        mutesIpv6s.add(mutesIpv6AndUid['ipv6']);
        mutesUids.add(mutesIpv6AndUid['uid']);
      });
      if ( isDisplayUid(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: currentUserDoc['uid'], ipv6: ipv6) ) {
        await updateCommentNotificationsOfPassiveUser(currentSongMap: currentSongMap, currentUserDoc: currentUserDoc, passiveUserDoc: passiveUserDoc, newCommentMap: commentMap);
      }
    }
    if (commentScrollFlashBarCount <= commentScrollFlashBarConstantCount) {
      commentScrollFlashBarCount += 1;
      await prefs.setInt('commentScrollFlashBarCount', commentScrollFlashBarCount);
    }
  }


  Map<String,dynamic> makeCommentMap(DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap) {
    final commentMap = {
      'comment': comment,
      'commentId': 'comment' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
      'createdAt': Timestamp.now(),
      'followersCount': currentUserDoc['followersCount'],
      'ipv6': ipv6,
      'isDelete': false,
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

  Future updateCommentNotificationsOfPassiveUser({ required Map<String,dynamic> currentSongMap, required DocumentSnapshot currentUserDoc, required DocumentSnapshot passiveUserDoc, required Map<String,dynamic> newCommentMap}) async {
    try{
      List<dynamic> commentNotifications = passiveUserDoc['commentNotifications'];
      final Map<String,dynamic> newCommentNotificationMap = {
        'comment': newCommentMap['comment'],
        'commentId': newCommentMap['commentId'],
        'createdAt': Timestamp.now(),
        'followersCount': currentUserDoc['followersCount'],
        'isDelete': false,
        'isNFTicon': currentUserDoc['isNFTicon'],
        'isOfficial': currentUserDoc['isOfficial'],
        'notificationId': 'commentNotification' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
        'passiveUid': currentSongMap['uid'],
        'postTitle': currentSongMap['title'],
        'postId': currentSongMap['postId'],
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

  void showTopFlash(BuildContext context,{ bool persistent = true}) {
    showFlash(
      context: context, 
      persistent: persistent,
      duration: Duration(seconds: 5),
      builder: (_, controller) {
        return Flash(
          controller: controller, 
          margin: EdgeInsets.all(8.0),
          backgroundColor: Theme.of(context).focusColor,
          behavior: FlashBehavior.fixed,
          position: FlashPosition.top,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Theme.of(context).highlightColor,
          boxShadows: kElevationToShadow[8],
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          onTap: () {
            controller.dismiss();
          },
          child: DefaultTextStyle(
            style: TextStyle(fontWeight: FontWeight.bold), 
            child: FlashBar(
              content: Text(
                '新しい順で上にスクロールするとコメントが表示されます',
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor
                ),
              ),
              indicatorColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.info,color: Theme.of(context).primaryColor,),
              primaryAction: TextButton(
                onPressed: () => controller.dismiss(),
                child: Text(
                  'DISMISS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
              ),
              
            )
          )
        );
      }
    );
  }
}