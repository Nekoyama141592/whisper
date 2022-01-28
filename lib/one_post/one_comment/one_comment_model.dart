// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/strings.dart';

final oneCommentProvider = ChangeNotifierProvider(
  (ref) => OneCommentModel()
);

class OneCommentModel extends ChangeNotifier {

  String commentId = '';
  bool isLoading = false;
  late DocumentSnapshot<Map<String,dynamic>> oneCommentDoc;
  Map<String,dynamic> oneCommentMap = {};

  Future<bool> init({ required String giveCommentId}) async {
    startLoading();
    if (commentId != giveCommentId) {
      oneCommentDoc = await FirebaseFirestore.instance.collection(commentsFieldKey).doc(giveCommentId).get();
    } 
    oneCommentMap = oneCommentDoc.data()!;
    endLoading();
    return oneCommentDoc.exists;
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