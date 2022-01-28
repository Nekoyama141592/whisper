// material
import 'package:flutter/material.dart';
// packages
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/enums.dart';
// domain
import 'package:whisper/domain/auth_notification/auth_notification.dart';
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
import 'package:whisper/domain/official_notification/official_notification.dart';

final notificaitonsProvider = ChangeNotifierProvider(
  (ref) => NotificationsModel()
);
class NotificationsModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  // notifications
  List<AuthNotification> authNotifications = [];
  List<CommentNotification> commentNotifications = [];
  List<ReplyNotification> replyNotifications = [];
  List<OfficialNotification> officialNotifications = [];
  
  NotificationsModel() {
    init();
  }

  Future<void> init() async {
    startLoading();
    final qshot = await notificationParentRef(uid: firebaseAuthCurrentUser!.uid).where(isReadFieldKey,isEqualTo: false).get();
    qshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> notificationDoc ) {
      final Map<String,dynamic> json = notificationDoc.data()!;
      final NotificationType notificationType = jsonToNotificationType(json: json);
      switch (notificationType) {
        case NotificationType.authNotification:
          final AuthNotification authNotification = AuthNotification.fromJson(json);
          authNotifications.add(authNotification);
        break;
        case NotificationType.commentNotification:
          final CommentNotification commentNotification = CommentNotification.fromJson(json);
          commentNotifications.add(commentNotification);
        break;
        case NotificationType.officialNotification:
          final OfficialNotification officialNotification = OfficialNotification.fromJson(json);
          officialNotifications.add(officialNotification);
        break;
        case NotificationType.replyNotification:
          final ReplyNotification replyNotification = ReplyNotification.fromJson(json);
          replyNotifications.add(replyNotification);
        break;
      }
    });
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

}