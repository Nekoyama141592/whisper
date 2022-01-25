// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post{
  Post({
    required this.accountName,
    required this.audioURL,
    required this.bookmarks,
    required this.bookmarkCount,
    required this.commentCount,
    required this.commentsState,
    required this.country,
    required this.createdAt,
    required this.description,
    required this.genre,
    required this.hashTags,
    required this.imageURLs,
    required this.impression,
    required this.ipv6,
    required this.isDelete,
    required this.isNFTicon,
    required this.isOfficial,
    required this.isPinned,
    required this.likes,
    required this.likeCount,
    required this.links,
    required this.noDisplayWords,
    required this.noDisplayIpv6AndUids,
    required this.negativeScore,
    required this.otherLinks,
    required this.playCount,
    required this.postId,
    required this.positiveScore,
    required this.score,
    required this.storageImageName,
    required this.storagePostName,
    required this.tagUids,
    required this.title,
    required this.tokenToSearch,
    required this.uid,
    required this.updatedAt,
    required this.userImageURL,
    required this.userName
  });
  String accountName;
  String audioURL;
  List<dynamic> bookmarks;
  int bookmarkCount;
  int commentCount;
  String commentsState;
  String country;
  dynamic createdAt;
  String description;
  String genre;
  List<dynamic> hashTags;
  List<dynamic> imageURLs;
  int impression;
  String ipv6;
  bool isDelete;
  bool isNFTicon;
  bool isOfficial;
  bool isPinned;
  List<dynamic> likes;
  int likeCount;
  List<dynamic> links;
  List<dynamic> noDisplayWords;
  List<dynamic> noDisplayIpv6AndUids;
  int negativeScore;
  List<dynamic> otherLinks;
  int playCount;
  String postId;
  double positiveScore;
  double score;
  String storageImageName;
  String storagePostName;
  List<dynamic> tagUids;
  Map<String,dynamic> tokenToSearch;
  String title;
  String uid;
  dynamic updatedAt;
  String userImageURL;
  String userName;
  
  factory Post.fromJson(Map<String,dynamic> json) => _$PostFromJson(json);

  Map<String,dynamic> toJson() => _$PostToJson(this);
}