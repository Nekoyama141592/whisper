import 'package:whisper/constants/strings.dart';

enum SortState { byLikedUidCount, byNewestFirst,byOldestFirst }
enum PostType { bookmarks, feeds, myProfile, postSearch, recommenders, userShow ,onePost} 
enum NotificationType { authNotification, commentNotification, replyNotification,officialNotification, }
dynamic jsonToNotificationType({ required Map<String,dynamic> json }) {
  final String notificationTypeString = json[notificationTypeMapKey];
  if (notificationTypeString == authNotificationType) {
    return NotificationType.authNotification;
  } else if (notificationTypeString == officialNotificationType) {
    return NotificationType.officialNotification;
  } else if (notificationTypeString == commentNotificationType) {
    return NotificationType.commentNotification;
  } else if (notificationTypeString == replyNotificationType) {
    return NotificationType.replyNotification;
  }
}
enum TokenType { bookmarkPostLabel,bookmarkPost,following,likePost,likePostComment,likePostCommentReply,searchHistory,readPost,watchlist,blockUser,mutePostComment,mutePost,mutePostCommentReply,muteUser }
dynamic jsonToTokenType({ required Map<String,dynamic> tokenMap}) {
  final String tokenTypeString = tokenMap[tokenTypeMapKey];
  if (tokenTypeString == bookmarkPostLabelTokenType) {
    return TokenType.bookmarkPostLabel;
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