// flutter
import 'package:flutter/material.dart';
// common
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
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

final replyNotificationsProvider = ChangeNotifierProvider(
  (ref) => ReplyNotificationsModel()
);

class ReplyNotificationsModel extends NotifiticationsModel {
  ReplyNotificationsModel() : super(
    basicDocType: BasicDocType.replyNotification,
    query: returnNotificationsColRef(uid: firebaseAuthCurrentUser()!.uid).where("notificationType",isEqualTo: "commentNotification"),
  );

  @override
  Future<void> getNewDocs() async {
    final qshot = await query.limit(oneTimeReadCount).endBeforeDocument(docs.first).get();
    for (final doc in qshot.docs) if (isNotNegativeBasicContent(basicDocType: basicDocType,doc: doc)) docs.insert(0, doc); 
  }

  @override
  Future<void> getDocs() async {
    final qshot = await query.limit(oneTimeReadCount).get();
    for (final doc in qshot.docs) if (isNotNegativeBasicContent(basicDocType: basicDocType,doc: doc)) docs.add(doc);
  }

  @override
  Future<void> getOldDocs() async {
    final qshot = await query.limit(oneTimeReadCount).startAfterDocument(docs.last).get();
    final reversed = qshot.docs.reversed.toList();
    for (final doc in reversed) if (isNotNegativeBasicContent(basicDocType: basicDocType,doc: doc)) docs.add(doc);
  }
  Future<void> onCardPressed({ required BuildContext context ,required MainModel mainModel , required OnePostModel onePostModel ,required OneCommentModel oneCommentModel, required  ReplyNotification replyNotification }) async {
    readNotificationIds.add(replyNotification.notificationId);
    final L10n l10n = returnL10n(context: context)!;
    bool postExists = await onePostModel.init(postId: replyNotification.postId, postDocRef: replyNotification.postDocRef as DocumentReference<Map<String,dynamic>> );
    if (postExists) {
      bool commentExists = await oneCommentModel.init(postCommentId: replyNotification.postCommentId, postCommentDocRef: replyNotification.postCommentDocRef as DocumentReference<Map<String,dynamic>> );
      commentExists ? routes.toOneCommentPage(context: context, mainModel: mainModel) : await voids.showBasicFlutterToast(context: context, msg: l10n.noCommentMsg);
    } else {
      await voids.showBasicFlutterToast(context: context, msg: l10n.noPostMsg );
    }
    notifyListeners();
    await returnNotificationDocRef(uid: firebaseAuthCurrentUser()!.uid, notificationId: replyNotification.notificationId ).update(replyNotification.toJson());
  }
}