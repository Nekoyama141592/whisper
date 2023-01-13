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
  switch(notificationTypeString) {
    case authNotificationType:
    return NotificationType.authNotification;
    case officialNotificationType:
    return NotificationType.officialNotification;
    case commentNotificationType:
    return NotificationType.postCommentNotification;
    case replyNotificationType:
    return NotificationType.postCommentReplyNotification;
    default:
    return NotificationType.authNotification;
  }
}

enum TokenType { bookmarkPostCategory,bookmarkPost,following,likePost,likePostComment,likePostCommentReply,searchHistory,readPost,watchlist,blockUser,mutePostComment,mutePost,mutePostCommentReply,muteUser }

TokenType jsonToTokenType({ required Map<String,dynamic> tokenMap}) {
  final String tokenTypeString = tokenMap[tokenTypeMapKey];
  switch(tokenTypeString) {
    case bookmarkPostCategoryTokenType: return TokenType.bookmarkPostCategory;
    case followingTokenType: return TokenType.following;
    case likePostTokenType: return TokenType.likePost;
    case likePostCommentTokenType: return TokenType.likePostComment;
    case likePostCommentReplyTokenType: return TokenType.likePostCommentReply;
    case searchHistoryTokenType: return TokenType.searchHistory;
    case readPostTokenType: return TokenType.readPost;
    case watchlistTokenType: return TokenType.watchlist;
    case blockUserTokenType: return TokenType.blockUser;
    case mutePostCommentTokenType: return TokenType.mutePostComment;
    case mutePostTokenType: return TokenType.mutePost;
    case mutePostCommentReplyTokenType: return TokenType.mutePostCommentReply;
    case muteUserTokenType: return TokenType.muteUser;
    case bookmarkPostTokenType: return TokenType.bookmarkPost;
    default: return TokenType.bookmarkPostCategory;
  }
}