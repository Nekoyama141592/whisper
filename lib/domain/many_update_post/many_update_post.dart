// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'many_update_post.g.dart';

@JsonSerializable()
class ManyUpdatePost {
  ManyUpdatePost({
    required this.audioURL,
    required this.bookmarks,
    required this.bookmarkCount,
    required this.commentCount,
    required this.commentsState,
    required this.country,
    required this.description,
    required this.genre,
    required this.hashTags,
    required this.imageURL,
    required this.impression,
    required this.ipv6,
    required this.playCount,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.isPinned,
    required this.likes,
    required this.likeCount,
    required this.link,
    required this.noDisplayWords,
    required this.noDisplayIpv6AndUids,
    required this.negativeScore,
    required this.otherLinks,
    required this.postId,
    required this.positiveScore,
    required this.score,
    required this.storageImageName,
    required this.storagePostName,
    required this.subUserName,
    required this.tagUids,
    required this.title,
    required this.uid,
    required this.userImageURL,
  });
  final String audioURL;
  final List<dynamic> bookmarks;
  final int bookmarkCount;
  final int commentCount;
  final String commentsState;
  final String country;
  final String description;
  final String genre;
  final List<dynamic> hashTags;
  final String imageURL;
  final int impression;
  final String ipv6;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  final bool isPinned;
  final List<dynamic> likes;
  final int likeCount;
  final String link;
  final List<dynamic> noDisplayWords;
  final List<dynamic> noDisplayIpv6AndUids;
  final int negativeScore;
  final List<dynamic> otherLinks;
  final int playCount;
  final String postId;
  final double positiveScore;
  final double score;
  final String storageImageName;
  final String storagePostName;
  final String subUserName;
  final List<dynamic> tagUids;
  final String title;
  final String uid;
  final String userImageURL;
  
  factory ManyUpdatePost.fromJson(Map<String,dynamic> json) => _$ManyUpdatePostFromJson(json);

  Map<String,dynamic> toJson() => _$ManyUpdatePostToJson(this);
}