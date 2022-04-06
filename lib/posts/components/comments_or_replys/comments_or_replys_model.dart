// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/post_comment_reply_report/post_comment_reply_report.dart';
import 'package:whisper/domain/post_comment_report/post_comment_report.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/domain/mute_reply/mute_reply.dart';
import 'package:whisper/domain/mute_comment/mute_comment.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// components
import 'package:whisper/details/report_contents_list_view.dart';
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
      notifyListeners();
      await showFlutterToast(backgroundColor: Theme.of(context).highlightColor,msg: muteUserMsg);
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
      notifyListeners();
      await showFlutterToast(backgroundColor: Theme.of(context).highlightColor,msg: mutePostCommentMsg);
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
      notifyListeners();
      await showFlutterToast(backgroundColor: Theme.of(context).colorScheme.secondary,msg: mutePostCommentReplyMsg);
      // process Backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteReply.toJson());
    } else {
      notifyListeners();
    }
  }
  void reportComment({ required BuildContext context,required MainModel mainModel, required WhisperPostComment whisperComment ,required DocumentSnapshot<Map<String,dynamic>> commentDoc }) {
    final selectedReportContentsNotifier = ValueNotifier<List<String>>([]);
    final String postCommentReportId = generatePostCommentReportId();
    final content = ReportContentsListView(selectedReportContentsNotifier: selectedReportContentsNotifier);
    final positiveActionBuilder = (_, controller, __) {
      return TextButton(
        onPressed: () async {
          final PostCommentReport postCommentReport = PostCommentReport(
            activeUid: mainModel.userMeta.uid, 
            comment: whisperComment.comment, 
            commentLanguageCode: whisperComment.commentLanguageCode,
            commentNegativeScore: whisperComment.commentNegativeScore,
            commentPositiveScore: whisperComment.commentPositiveScore,
            commentSentiment: whisperComment.commentSentiment,
            createdAt: Timestamp.now(), 
            others: '', 
            reportContent: returnReportContentString(selectedReportContents: selectedReportContentsNotifier.value), 
            passiveUid: whisperComment.uid,
            passiveUserImageURL: whisperComment.userImageURL,
            passiveUserName: whisperComment.userName,
            postCommentRef: commentDoc.reference,
            postCreatorUid: whisperComment.passiveUid,
            postId: whisperComment.postId,
          );
          await (controller as FlashController).dismiss();
          await showFlutterToast(backgroundColor: Theme.of(context).highlightColor,msg: reportPostCommentMsg );
          await muteComment(context: context, mainModel: mainModel, whisperComment: whisperComment);
          await returnPostCommentReportDocRef(postCommentDoc: commentDoc, postCommentReportId: postCommentReportId).set(postCommentReport.toJson());
        }, 
        child: Text(choiceModalMsg, style: textStyle(context: context), )
      );
    };
    showFlashDialogue(context: context, content: content, titleText: reportTitle, positiveActionBuilder: positiveActionBuilder);
  }
  void reportReply({ required BuildContext context,required MainModel mainModel, required WhisperReply whisperReply,required DocumentSnapshot<Map<String,dynamic>> postCommentReplyDoc }) {
    final selectedReportContentsNotifier = ValueNotifier<List<String>>([]);
    final postCommentReplyReportId = generatePostCommentReplyReportId();
    final content = ReportContentsListView(selectedReportContentsNotifier: selectedReportContentsNotifier);
    final positiveActionBuilder = (_, controller, __) {
      return TextButton(
        onPressed: () async {
          final PostCommentReplyReport postCommentReplyReport = PostCommentReplyReport(
            activeUid: mainModel.userMeta.uid,
            createdAt: Timestamp.now(),
            others: '',
            reportContent: returnReportContentString(selectedReportContents: selectedReportContentsNotifier.value), 
            passiveUid: whisperReply.uid,
            passiveUserImageURL: whisperReply.userImageURL, 
            passiveUserName: whisperReply.userName, 
            postCommentId: whisperReply.postCommentId, 
            postCommentReplyId: whisperReply.postCommentReplyId, 
            postCommentReplyRef: postCommentReplyDoc.reference, 
            postCreatorUid: whisperReply.postCreatorUid, 
            postId: whisperReply.postId, 
            reply: whisperReply.reply, 
            replyLanguageCode: whisperReply.replyLanguageCode, 
            replyNegativeScore: whisperReply.replyNegativeScore, 
            replyPositiveScore: whisperReply.replyPositiveScore, 
            replySentiment: whisperReply.replySentiment
          );
          await (controller as FlashController).dismiss();
          await showFlutterToast(backgroundColor: Theme.of(context).highlightColor,msg: reportPostCommentReplyMsg );
          await muteReply(context: context, mainModel: mainModel, whisperReply: whisperReply);
          await returnPostCommentReplyReportDocRef(postCommentReplyDoc: postCommentReplyDoc, postCommentReplyReportId: postCommentReplyReportId).set(postCommentReplyReport.toJson());
        }, 
        child: Text(choiceModalMsg, style: textStyle(context: context), )
      );
    };
    showFlashDialogue(context: context, content: content, titleText: reportTitle, positiveActionBuilder: positiveActionBuilder);
  }
}
