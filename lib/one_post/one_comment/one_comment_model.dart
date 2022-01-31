// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/domain/comment/whisper_comment.dart';

final oneCommentProvider = ChangeNotifierProvider(
  (ref) => OneCommentModel()
);

class OneCommentModel extends ChangeNotifier {

  String commentId = '';
  bool isLoading = false;
  late DocumentSnapshot<Map<String,dynamic>> oneCommentDoc;
  late WhisperComment oneWhisperComment;

  Future<bool> init({ required String giveCommentId,required String postCreatorUid,required String postId }) async {
    startLoading();
    if (commentId != giveCommentId) {
      // oneCommentDoc = await postCommentDocRef(uid: passiveUid,)
      
    } 
    oneWhisperComment = WhisperComment.fromJson(oneCommentDoc.data()!);
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