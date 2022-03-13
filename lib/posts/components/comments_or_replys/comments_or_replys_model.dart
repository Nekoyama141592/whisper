// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart';
// domain
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/block_user/block_user.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/domain/mute_reply/mute_reply.dart';
import 'package:whisper/domain/mute_comment/mute_comment.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// model 
import 'package:whisper/main_model.dart';

final commentsOrReplysProvider = ChangeNotifierProvider(
  (ref) => CommentsOrReplysModel()
);

class CommentsOrReplysModel extends ChangeNotifier {
  Future<void> muteUser({ required BuildContext context,required MainModel mainModel, required String passiveUid,}) async {
    if (mainModel.muteUids.contains(passiveUid) == false) {
      // process set
      final Timestamp now = Timestamp.now();
      final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.muteUser );
      final MuteUser muteUser = MuteUser(activeUid:mainModel.userMeta.uid, passiveUid: passiveUid, createdAt: now,tokenId: tokenId, tokenType: muteUserTokenType );
      // processUI
      mainModel.muteUsers.add(muteUser);
      mainModel.muteUids.add(muteUser.passiveUid);
      showSnackBar(context: context, text: muteUserMsg ); // notifyListeners() not working
      // process backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteUser.toJson());
    } else {
      notifyListeners();
    }
  }

  // Future<void> blockUser({ required BuildContext context,required MainModel mainModel, required String passiveUid,}) async {
  //   if (mainModel.blockUids.contains(passiveUid) == false) {
  //     // process set
  //     final Timestamp now = Timestamp.now();
  //     final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.blockUser );
  //     final BlockUser blockUser = BlockUser(createdAt: now, activeUid: mainModel.userMeta.uid,passiveUid: passiveUid,tokenId: tokenId,tokenType: blockUserTokenType );
  //     // process UI
  //     mainModel.blockUsers.add(blockUser);
  //     mainModel.blockUids.add(blockUser.passiveUid);
  //     showSnackBar(context: context, text: blockUserMsg ); // notifyListeners() not working
  //     // process Backend
  //     await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(blockUser.toJson());
  //   } else {
  //     notifyListeners();
  //   }
  // }

  Future<void> muteComment({ required BuildContext context,required MainModel mainModel, required WhisperPostComment whisperComment }) async {
    if (mainModel.mutePostCommentIds.contains(whisperComment.postCommentId) == false) {
        // process set
      final Timestamp now = Timestamp.now();
      final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.mutePostComment );
      final String postCommentId = whisperComment.postCommentId;
      final MuteComment muteComment = MuteComment(activeUid: mainModel.userMeta.uid,postCommentId: postCommentId,createdAt: now, tokenId: tokenId, tokenType: mutePostCommentTokenType,postCommentDocRef: returnPostCommentDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId, postCommentId: postCommentId, ), );
      // process UI
      mainModel.mutePostCommentIds.add(postCommentId);
      mainModel.mutePostComments.add(muteComment);
      showSnackBar(context: context, text: mutePostCommentMsg ); // notifyListeners() not working
      // process Backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteComment.toJson());
    } else {
      notifyListeners();
    }
  }

  Future<void> muteReply({ required BuildContext context,required MainModel mainModel, required WhisperReply whisperReply }) async {
    if (mainModel.mutePostCommentReplyIds.contains(whisperReply.postCommentReplyId) == false) {
      // process set
      final Timestamp now = Timestamp.now();
      final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.mutePostCommentReply );
      final MuteReply muteReply = MuteReply(activeUid: mainModel.userMeta.uid, createdAt: now, postCommentReplyId: whisperReply.postCommentReplyId, tokenType: mutePostCommentReplyTokenType, postCommentReplyDocRef: postDocRefToPostCommentReplyDocRef(postDocRef: whisperReply.postDocRef, postCommentId: whisperReply.postCommentId, postCommentReplyId: whisperReply.postCommentReplyId ) );
      // process UI
      mainModel.mutePostCommentReplyIds.add(muteReply.postCommentReplyId);
      mainModel.mutePostCommentReplys.add(muteReply);
      showSnackBar(context: context, text: mutePostCommentReplyMsg ); // notifyListeners() not working
      // process Backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteReply.toJson());
    } else {
      notifyListeners();
    }
  }
}
