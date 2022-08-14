import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_comment_reply_report.freezed.dart';
part 'post_comment_reply_report.g.dart';

@freezed
abstract class PostCommentReplyReport with _$PostCommentReplyReport {
 const factory PostCommentReplyReport({
    required String activeUid,
    required dynamic createdAt,
    required String others,
    required String reportContent,
    required String passiveUid,
    required String passiveUserName,
    required String postCommentId,
    required String postCommentReplyId,
    required dynamic postCommentReplyDocRef,
    required String postCreatorUid,
    required String postId,
    required String reply,
    required String replyLanguageCode,
    required num replyNegativeScore,
    required num replyPositiveScore,
    required String replySentiment,
  }) = _PostCommentReplyReport;
 factory PostCommentReplyReport.fromJson(Map<String, dynamic> json) => _$PostCommentReplyReportFromJson(json);
}