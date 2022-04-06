// packages
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post{
  Post({
    required this.accountName,
    required this.audioURL,
    required this.bookmarkCount,
    required this.commentsState,
    required this.country,
    required this.createdAt,
    required this.description,
    required this.descriptionLanguageCode,
    required this.descriptionNegativeScore,
    required this.descriptionPositiveScore,
    required this.descriptionSentiment,
    required this.genre,
    required this.hashTags,
    required this.imageURLs,
    required this.impressionCount,
    required this.isNFTicon,
    required this.isOfficial,
    required this.isPinned,
    required this.likeCount,
    required this.links,
    required this.mainWalletAddress,
    required this.muteCount,
    required this.nftIconInfo,
    required this.playCount,
    required this.postState,
    required this.postId,
    required this.postCommentCount,
    required this.recommendState,
    required this.reportCount,
    required this.score,
    required this.storagePostName,
    required this.searchToken,
    required this.tagAccountNames,
    required this.title,
    required this.titleLanguageCode,
    required this.titleNegativeScore,
    required this.titlePositiveScore,
    required this.titleSentiment,
    required this.uid,
    required this.updatedAt,
    required this.userImageURL,
    required this.userImageNegativeScore,
    required this.userName,
    required this.userNameLanguageCode,
    required this.userNameNegativeScore,
    required this.userNamePositiveScore,
    required this.userNameSentiment,
  });
  String accountName;
  String audioURL;
  int bookmarkCount;
  String commentsState;
  String country;
  dynamic createdAt;
  String description;
  // un used
  final String descriptionLanguageCode;
  final num descriptionNegativeScore;
  final num descriptionPositiveScore;
  final String descriptionSentiment;
  String genre;
  List<String> hashTags;
  List<String> imageURLs;
  int impressionCount;
  bool isNFTicon;
  bool isOfficial;
  bool isPinned;
  int likeCount;
  List<Map<String,dynamic>> links;
  String mainWalletAddress;
  final int muteCount;
  Map<String,dynamic> nftIconInfo;
  int playCount;
  String postState;
  int postCommentCount;
  String postId;
  String recommendState;
  final int reportCount;
  num score;
  final String storagePostName;
  Map<String,dynamic> searchToken;
  List<String> tagAccountNames;
  String title;
  final titleLanguageCode;
  final num titleNegativeScore;
  final num titlePositiveScore;
  final String titleSentiment;
  final String uid;
  dynamic updatedAt;
  String userImageURL;
  final num userImageNegativeScore;
  String userName;
  final String userNameLanguageCode;
  final num userNameNegativeScore;
  final num userNamePositiveScore;
  final String userNameSentiment;
  
  factory Post.fromJson(Map<String,dynamic> json) => _$PostFromJson(json);

  Map<String,dynamic> toJson() => _$PostToJson(this);
}