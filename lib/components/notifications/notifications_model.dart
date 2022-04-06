// material
import 'package:flutter/material.dart';
// packages
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/voids.dart' as voids;
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
  List<DocumentSnapshot<Map<String,dynamic>>> notifications = [];
  Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream = returnNotificationsColRef(uid: firebaseAuthCurrentUser()!.uid).where(isReadFieldKey,isEqualTo: false).limit(oneTimeReadCount).snapshots();
  final query = returnNotificationsColRef(uid: firebaseAuthCurrentUser()!.uid).where(isReadFieldKey,isEqualTo: false);
  // refresh
  RefreshController commentRefreshController = RefreshController(initialRefresh: false);
  RefreshController replyRefreshController = RefreshController(initialRefresh: false);
  // read
  List<String> readPostCommentNotificationIds = [];
  List<String> readPostCommentReplyNotificationIds = [];
  
  NotificationsModel() {
    init();
  }

  Future<void> init() async {
    await onReload();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await getNewNotifications();
    commentRefreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload() async {
    startLoading();
    await getNotifications();
    endLoading();
  }

  Future<void> onLoading() async {
    await getOldNotifications();
    commentRefreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getNewNotifications() async {
    await voids.processNewDocs(query: query, docs: notifications );
  }

  Future<void> getNotifications() async {
    await voids.processBasicDocs(query: query, docs: notifications);
  }

  Future<void> getOldNotifications() async {
    await voids.processOldDocs(query: query, docs: notifications );
  }

  Future<void> onCommentNotificationPressed({ required BuildContext context ,required MainModel mainModel , required OnePostModel onePostModel ,required OneCommentModel oneCommentModel, required  CommentNotification commentNotification }) async {
    commentNotification.isRead = true;
    readPostCommentNotificationIds.add(commentNotification.notificationId);
    final thisElement = notifications.where((element) => element.id == commentNotification.notificationId ).toList().first;
    final i = notifications.indexOf(thisElement);
    notifications[i].data()![isReadMapKey] = true;
    bool postExists = await onePostModel.init(postId: commentNotification.postId, postDocRef: commentNotification.postDocRef as DocumentReference<Map<String,dynamic>> );
    if (postExists) {
      bool commentExists = await oneCommentModel.init(postCommentId: commentNotification.postCommentId, postCommentDocRef: commentNotification.postCommentDocRef as DocumentReference<Map<String,dynamic>> );
      if (commentExists) {
        routes.toOneCommentPage(context: context, mainModel: mainModel);
      } else {
        voids.showBasicFlutterToast(context: context, msg: 'そのコメントは削除されています');
      }
    } else {
      voids.showBasicFlutterToast(context: context, msg: '元の投稿が削除されています');
    }
    notifyListeners();
    await returnNotificationDocRef(uid: firebaseAuthCurrentUser()!.uid, notificationId: commentNotification.notificationId ).update(commentNotification.toJson());
  }

  Future<void> onReplyNotificationPressed({ required BuildContext context ,required MainModel mainModel , required OnePostModel onePostModel ,required OneCommentModel oneCommentModel, required  ReplyNotification replyNotification }) async {
    replyNotification.isRead = true;
    readPostCommentReplyNotificationIds.add(replyNotification.notificationId);
    final thisElement = notifications.where((element) => element.id == replyNotification.notificationId ).toList().first;
    final i = notifications.indexOf(thisElement);
    notifications[i].data()![isReadMapKey] = true;
    bool postExists = await onePostModel.init(postId: replyNotification.postId, postDocRef: replyNotification.postDocRef as DocumentReference<Map<String,dynamic>> );
    if (postExists) {
      bool commentExists = await oneCommentModel.init(postCommentId: replyNotification.postCommentId, postCommentDocRef: replyNotification.postCommentDocRef as DocumentReference<Map<String,dynamic>> );
      if (commentExists) {
        routes.toOneCommentPage(context: context, mainModel: mainModel);
      } else {
        voids.showBasicFlutterToast(context: context, msg: 'そのコメントは削除されています');
      }
    } else {
      voids.showBasicFlutterToast(context: context, msg: '元の投稿が削除されています');
    }
    notifyListeners();
    await returnNotificationDocRef(uid: firebaseAuthCurrentUser()!.uid, notificationId: replyNotification.notificationId ).update(replyNotification.toJson());
  }

}
