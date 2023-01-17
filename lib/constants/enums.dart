import 'package:whisper/constants/strings.dart';

enum CommentsState {isOpen, isLocked}

enum SortState { byLikeUidCount, byNewestFirst,byOldestFirst }

enum Gender { male, female, others, noResponse }

// use on firestore
enum PostState { basic, repost}

enum DmState {onlyFollowingAndFollowed}

enum RecommendState {isRecommendable}
// use on front
enum PostType { bookmarks, createPost,feeds, myProfile, postSearch, recommenders, userShow ,onePost} 

enum NotificationType { authNotification, postCommentNotification, postCommentReplyNotification,officialNotification, }

enum BasicDocType { commentNotification,muteUser,postComment,postCommentReply,replyNotification,searchedUser }

NotificationType jsonToNotificationType({ required Map<String,dynamic> json }) {
  final String notificationTypeString = json[notificationTypeMapKey];
  return NotificationType.values.byName(notificationTypeString);
}

enum TokenType { bookmarkPostCategory,bookmarkPost,following,likePost,likePostComment,likePostCommentReply,searchHistory,readPost,watchlist,blockUser,mutePostComment,mutePost,mutePostCommentReply,muteUser }

TokenType jsonToTokenType({ required Map<String,dynamic> tokenMap}) {
  final String tokenTypeString = tokenMap[tokenTypeMapKey];
  return TokenType.values.byName(tokenTypeString);
}