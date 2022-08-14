import 'package:freezed_annotation/freezed_annotation.dart';

part 'like_reply.freezed.dart';
part 'like_reply.g.dart';

@freezed
abstract class LikeReply with _$LikeReply {
 const factory LikeReply({
    required String activeUid,
    required dynamic createdAt,
    required String postCommentReplyId,
    required String tokenId,
    required String tokenType,
    required dynamic postCommentReplyDocRef,
  }) = _LikeReply;
 factory LikeReply.fromJson(Map<String, dynamic> json) => _$LikeReplyFromJson(json);
}