// material
import 'package:flutter/material.dart';
// packages
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';

final notificationsProvider = ChangeNotifierProvider(
  (ref) => NotificationsModel()
);
class NotificationsModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  // notifications
  Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream = returnNotificationsColRef(uid: firebaseAuthCurrentUser!.uid).where(isReadFieldKey,isEqualTo: false).limit(oneTimeReadCount).snapshots();
  
  NotificationsModel() {
    init();
  }

  Future<void> init() async {
    startLoading();
    endLoading();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> onCommentNotificationPressed({ required BuildContext context ,required MainModel mainModel , required OnePostModel onePostModel ,required OneCommentModel oneCommentModel, required  CommentNotification commentNotification }) async {
    commentNotification.isRead = true;
    bool postExists = await onePostModel.init(postId: commentNotification.postId, postDocRef: commentNotification.postDocRef as DocumentReference<Map<String,dynamic>> );
    if (postExists) {
      bool commentExists = await oneCommentModel.init(postCommentId: commentNotification.postCommentId, postCommentDocRef: commentNotification.postCommentDocRef as DocumentReference<Map<String,dynamic>> );
      if (commentExists) {
        routes.toOneCommentPage(context: context, mainModel: mainModel);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('そのコメントは削除されています')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('元の投稿が削除されています')));
    }
    notifyListeners();
  }

  Future<void> onReplyNotificationPressed({ required BuildContext context ,required MainModel mainModel , required OnePostModel onePostModel ,required OneCommentModel oneCommentModel, required  ReplyNotification replyNotification }) async {
    replyNotification.isRead = true;
    bool postExists = await onePostModel.init(postId: replyNotification.postId, postDocRef: replyNotification.postDocRef as DocumentReference<Map<String,dynamic>> );
    if (postExists) {
      bool commentExists = await oneCommentModel.init(postCommentId: replyNotification.postCommentId, postCommentDocRef: replyNotification.postCommentDocRef as DocumentReference<Map<String,dynamic>> );
      if (commentExists) {
        routes.toOneCommentPage(context: context, mainModel: mainModel);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('そのコメントは削除されています')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('元の投稿が削除されています')));
    }
    notifyListeners();
  }
}
