// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post{
  Post({
    required this.audioURL,
    required this.commentsState,
    required this.country,
    required this.description,
    required this.genre,
    required this.hashTags,
    required this.imageURL,
    required this.ipv6,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.isPinned,
    required this.link,
    required this.noDisplayWords,
    required this.noDisplayIpv6AndUids,
    required this.otherLinks,
    required this.postId,
    required this.positiveScore,
    required this.score,
    required this.storageImageName,
    required this.storagePostName,
    required this.tagUids,
    required this.title,
    required this.uid,
    required this.userImageURL,
    required this.userName
  });
  final String audioURL;
  final String commentsState;
  final String country;
  final String description;
  final String genre;
  final List<dynamic> hashTags;
  final String imageURL;
  final String ipv6;
  final bool isDelete;
  final bool isNFTicon;
  final bool isOfficial;
  final bool isPinned;
  final String link;
  final List<dynamic> noDisplayWords;
  final List<dynamic> noDisplayIpv6AndUids;
  final List<dynamic> otherLinks;
  final String postId;
  final double positiveScore;
  final double score;
  final String storageImageName;
  final String storagePostName;
  final List<dynamic> tagUids;
  final String title;
  final String uid;
  final String userImageURL;
  final String userName;
  
  factory Post.fromJson(Map<String,dynamic> json) => _$PostFromJson(json);

  Map<String,dynamic> toJson() => _$PostToJson(this);
}