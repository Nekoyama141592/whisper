// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whipser_reply.g.dart';

@JsonSerializable()
class WhisperReply {
  WhisperReply({
    required this.accountName,
    required this.createdAt,
    required this.postCommentId,
    required this.followerCount,
    required this.isDelete,
    required this.isHidden,
    required this.isNFTicon,
    required this.isOfficial,
    required this.likeCount,
    required this.mainWalletAddress,
    required this.negativeScore,
    required this.nftIconInfo,
    required this.passiveUid,
    required this.postId,
    required this.positiveScore,
    required this.reply,
    required this.postCommentReplyId,
    required this.postCreatorUid,
    required this.postDocRef,
    required this.score,
    required this.uid,
    required this.updatedAt,
    required this.userName,
    required this.userImageURL
  });
  final String accountName;
  final dynamic createdAt;
  final int followerCount;
  final bool isDelete;
  final bool isHidden;
  final bool isNFTicon;
  final bool isOfficial;
  int likeCount;
  final String mainWalletAddress;
  final num negativeScore;
  final Map<String,dynamic> nftIconInfo;
  final String passiveUid;
  final String postId;
  final num positiveScore;
  final String reply;
  final String postCommentId;
  final String postCommentReplyId;
  final String postCreatorUid;
  final dynamic postDocRef;
  final num score;
  final String uid;
  final dynamic updatedAt;
  final String userName;
  final String userImageURL;

  factory WhisperReply.fromJson(Map<String,dynamic> json) => _$WhisperReplyFromJson(json);

  Map<String,dynamic> toJson() => _$WhisperReplyToJson(this);
}