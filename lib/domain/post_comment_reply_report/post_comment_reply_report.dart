// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_comment_reply_report.g.dart';

@JsonSerializable()
class PostCommentReplyReport {
  PostCommentReplyReport({
    required this.activeUid,
    required this.createdAt,
    required this.others,
    required this.reportContent,
    required this.passiveUid,
    required this.passiveUserImageURL,
    required this.passiveUserName,
    required this.postCommentId,
    required this.postCommentReplyId,
    required this.postCommentReplyRef,
    required this.postCreatorUid,
    required this.postId,
    required this.reply,
    required this.replyLanguageCode,
    required this.replyNegativeScore,
    required this.replyPositiveScore,
    required this.replySentiment,
  });
  
  final String activeUid;
  final dynamic createdAt;
  final String others;
  final String reportContent;
  final String passiveUid;
  final String passiveUserImageURL;
  final String passiveUserName;
  final String postCommentId;
  final String postCommentReplyId;
  final dynamic postCommentReplyRef;
  final String postCreatorUid;
  final String postId;
  final String reply;
  final String replyLanguageCode;
  final num replyNegativeScore;
  final num replyPositiveScore;
  final String replySentiment;

  factory PostCommentReplyReport.fromJson(Map<String,dynamic> json) => _$PostCommentReplyReportFromJson(json);

  Map<String,dynamic> toJson() => _$PostCommentReplyReportToJson(this);
}