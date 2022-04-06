// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_comment_report.g.dart';

@JsonSerializable()
class PostCommentReport {
  PostCommentReport({
    required this.activeUid,
    required this.comment,
    required this.commentLanguageCode,
    required this.commentNegativeScore,
    required this.commentPositiveScore,
    required this.commentSentiment,
    required this.createdAt,
    required this.others,
    required this.reportContent,
    required this.passiveUid,
    required this.passiveUserName,
    required this.postCommentDocRef,
    required this.postCreatorUid,
    required this.postId,
  });
  
  final String activeUid;
  final String comment;
  final String commentLanguageCode;
  final num commentPositiveScore;
  final num commentNegativeScore;
  final String commentSentiment;
  final dynamic createdAt;
  final String others;
  final String reportContent;
  final String passiveUid;
  final String passiveUserName;
  final dynamic postCommentDocRef;
  final String postCreatorUid;
  final String postId;

  factory PostCommentReport.fromJson(Map<String,dynamic> json) => _$PostCommentReportFromJson(json);

  Map<String,dynamic> toJson() => _$PostCommentReportToJson(this);
}