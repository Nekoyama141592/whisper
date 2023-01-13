// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// abstract_model
import 'package:whisper/abstract_models/docs_model.dart';
// common
import 'package:whisper/constants/enums.dart';

abstract class NotifiticationsModel extends DocsModel {
  NotifiticationsModel({required BasicDocType basicDocType,required Query<Map<String, dynamic>> query}) : super(basicDocType: basicDocType,query: query);
  List<String> readNotificationIds = [];
  bool isReadNotification(String notificationId) => readNotificationIds.contains(notificationId);
}