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

dynamic jsonToNotificationType({ required Map<String,dynamic> json }) {
  final String notificationTypeString = json[notificationTypeMapKey];
  if (notificationTypeString == authNotificationType) {
    return NotificationType.authNotification;
  } else if (notificationTypeString == officialNotificationType) {
    return NotificationType.officialNotification;
  } else if (notificationTypeString == commentNotificationType) {
    return NotificationType.postCommentNotification;
  } else if (notificationTypeString == replyNotificationType) {
    return NotificationType.postCommentReplyNotification;
  }
}

enum TokenType { bookmarkPostCategory,bookmarkPost,following,likePost,likePostComment,likePostCommentReply,searchHistory,readPost,watchlist,blockUser,mutePostComment,mutePost,mutePostCommentReply,muteUser }

dynamic jsonToTokenType({ required Map<String,dynamic> tokenMap}) {
  final String tokenTypeString = tokenMap[tokenTypeMapKey];
  if (tokenTypeString == bookmarkPostCategoryTokenType) {
    return TokenType.bookmarkPostCategory;
  } else if(tokenTypeString == followingTokenType) {
    return TokenType.following;
  } else if (tokenTypeString == likePostTokenType) {
    return TokenType.likePost;
  } else if (tokenTypeString == likePostCommentTokenType) {
    return TokenType.likePostComment;
  } else if (tokenTypeString == likePostCommentReplyTokenType) {
    return TokenType.likePostCommentReply;
  } else if (tokenTypeString == searchHistoryTokenType) {
    return TokenType.searchHistory;
  } else if (tokenTypeString == readPostTokenType) {
    return TokenType.readPost;
  } else if (tokenTypeString == watchlistTokenType) {
    return TokenType.watchlist;
  } else if (tokenTypeString == blockUserTokenType) {
    return TokenType.blockUser;
  } else if (tokenTypeString == mutePostCommentTokenType) {
    return TokenType.mutePostComment;
  } else if (tokenTypeString == mutePostTokenType) {
    return TokenType.mutePost;
  } else if (tokenTypeString == mutePostCommentReplyTokenType) {
    return TokenType.mutePostCommentReply;
  } else if (tokenTypeString == muteUserTokenType) {
    return TokenType.muteUser;
  } else if (tokenTypeString == bookmarkPostTokenType) {
    return TokenType.bookmarkPost;
  }
}