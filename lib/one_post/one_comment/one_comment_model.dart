// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';

final oneCommentProvider = ChangeNotifierProvider(
  (ref) => OneCommentModel()
);

class OneCommentModel extends ChangeNotifier {

  String indexCommentId = '';
  bool isLoading = false;
  late DocumentSnapshot<Map<String,dynamic>> oneCommentDoc;
  late WhisperPostComment oneWhisperComment;

  Future<bool> init({ required String postCommentId, required DocumentReference<Map<String,dynamic>> postCommentDocRef }) async {
    startLoading();
    if (indexCommentId != postCommentId) {
      oneCommentDoc = await postCommentDocRef.get();
    } 
    oneWhisperComment = WhisperPostComment.fromJson(oneCommentDoc.data()!);
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