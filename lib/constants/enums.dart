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
enum TokenType { bookmarkLabel,bookmarkPost,following,likePost,likeComment,likeReply,searchHistory,readPost,watchlist,blockUser,muteComment,mutePost,muteReply,muteUser }
dynamic jsonToTokenType({ required Map<String,dynamic> tokenMap}) {
  final String tokenTypeString = tokenMap[tokenTypeMapKey];
  if (tokenTypeString == bookmarkLabelTokenType) {
    return TokenType.bookmarkLabel;
  } else if(tokenTypeString == followingTokenType) {
    return TokenType.following;
  } else if (tokenTypeString == likePostTokenType) {
    return TokenType.likePost;
  } else if (tokenTypeString == likeCommentTokenType) {
    return TokenType.likeComment;
  } else if (tokenTypeString == likeReplyTokenType) {
    return TokenType.likeReply;
  } else if (tokenTypeString == searchHistoryTokenType) {
    return TokenType.searchHistory;
  } else if (tokenTypeString == readPostTokenType) {
    return TokenType.readPost;
  } else if (tokenTypeString == watchlistTokenType) {
    return TokenType.watchlist;
  } else if (tokenTypeString == blockUserTokenType) {
    return TokenType.blockUser;
  } else if (tokenTypeString == muteCommentTokenType) {
    return TokenType.muteComment;
  } else if (tokenTypeString == mutePostTokenType) {
    return TokenType.mutePost;
  } else if (tokenTypeString == muteReplyTokenType) {
    return TokenType.muteReply;
  } else if (tokenTypeString == muteUserTokenType) {
    return TokenType.muteUser;
  }
}