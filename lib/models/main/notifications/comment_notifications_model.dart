// flutter
import 'package:flutter/material.dart';
// common
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// packages
import 'package:whisper/l10n/l10n.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/models/one_post/one_post_model.dart';
import 'package:whisper/models/one_comment/one_comment_model.dart';
// abstract_model
import 'package:whisper/abstract_models/notifications_model.dart';

final commentNotificationsProvider = ChangeNotifierProvider(
  (ref) => CommentNotificationsModel()
);

class CommentNotificationsModel extends NotifiticationsModel {
  CommentNotificationsModel() : super(
    basicDocType: BasicDocType.commentNotification,
    query: returnNotificationsColRef(uid: firebaseAuthCurrentUser()!.uid).where("notificationType",isEqualTo: "replyNotification")
  );
  @override
  Future<void> getNewDocs() async {}
  @override
  Future<void> getDocs() async {}
  @override
  Future<void> getOldDocs() async {}

  Future<void> onCardPressed({ required BuildContext context ,required MainModel mainModel , required OnePostModel onePostModel ,required OneCommentModel oneCommentModel, required  CommentNotification commentNotification }) async {
    readNotificationIds.add(commentNotification.notificationId);
    final L10n l10n = returnL10n(context: context)!;
    bool postExists = await onePostModel.init(postId: commentNotification.postId, postDocRef: commentNotification.postDocRef as DocumentReference<Map<String,dynamic>> );
    if (postExists) {
      bool commentExists = await oneCommentModel.init(postCommentId: commentNotification.postCommentId, postCommentDocRef: commentNotification.postCommentDocRef as DocumentReference<Map<String,dynamic>> );
      commentExists ? routes.toOneCommentPage(context: context, mainModel: mainModel) : await voids.showBasicFlutterToast(context: context, msg: l10n.noCommentMsg);
    } else {
      await voids.showBasicFlutterToast(context: context, msg: l10n.noPostMsg );
    }
    notifyListeners();
    await returnNotificationDocRef(uid: firebaseAuthCurrentUser()!.uid, notificationId: commentNotification.notificationId ).update(commentNotification.toJson());
  }
}