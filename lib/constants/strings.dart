// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';

const String postExtension = '.aac';
const String imageExtension = '.jpeg';
const String onlyFollowingAndFollowedString = 'onlyFollowingAndFollowed';
const String recommendableString = 'recommendable';
String microSecondsString({ required DateTime now }) {
  return DateTime.now().microsecondsSinceEpoch.toString();
}
String storageUserImageName({ required DateTime now }) {
  return 'userImage' + microSecondsString(now: now) + imageExtension;
}
String postImageName({ required DateTime now }) {
  return 'postImage' + microSecondsString(now: now) + imageExtension;
}
String returnBookmarkLabelId({ required DateTime now }) {
  return  bookmarkLabelString + now.microsecondsSinceEpoch.toString();
}
String returnTokenId({ required DateTime now }) {
  return tokenString + microSecondsString(now: now);
}
String returnTokenTypeString({ required TokenType tokenType } ) {
  return tokenType.toString().substring(tokenTypeStartIndex);
}
String returnNotificationId({ required Timestamp now }) {
  return notificationString + microSecondsString(now: now.toDate());
}
String returnNotificationTypeString({ required NotificationType notifcationType }) {
  return notifcationType.toString().substring(notificationTypeStartIndex);
}
// strings
const String bookmarkLabelString = 'bookmarkLabel';
const String bookmarkLabelsString = 'bookmarkLabels';
const String tokenString = 'token';
const String tokensString = 'tokens';
const String notificationString = 'notification';
const String unNamedString = 'unNamed';
// prefs
const String bookmarkPostIdsPrefsKey = 'bookmarkPostIds';
const String likePostIdsPrefsKey = 'likePostIds';
const String likeCommentIdsPrefsKey = 'likeCommentIds';
const String likeReplyIdsPrefsKey = 'likeReplyIds';
const String muteCommentIdsPrefsKey = 'muteCommentIds';
const String muteReplyIdsPrefsKey = 'muteReplyIds';
const String mutePostIdsPrefsKey = 'mutePostIds';
const String readPostIdsPrefsKey = 'readPostIds';
const String speedPrefsKey = 'speed';
// tokenTypes
final String blockUserTokenType = returnTokenTypeString(tokenType: TokenType.blockUser);
final String bookmarkLabelTokenType = returnTokenTypeString(tokenType: TokenType.bookmarkLabel);
final String bookmarkPostTokenType = returnTokenTypeString(tokenType: TokenType.bookmarkPost);
final String followingTokenType = returnTokenTypeString(tokenType: TokenType.following);
final String likePostTokenType = returnTokenTypeString(tokenType: TokenType.likePost);
final String likeCommentTokenType = returnTokenTypeString(tokenType: TokenType.likeComment);
final String watchlistTokenType = returnTokenTypeString(tokenType: TokenType.watchlist);
final String muteCommentTokenType = returnTokenTypeString(tokenType: TokenType.muteComment);
final String mutePostTokenType = returnTokenTypeString(tokenType: TokenType.mutePost);
final String muteReplyTokenType = returnTokenTypeString(tokenType: TokenType.muteReply);
final String muteUserTokenType = returnTokenTypeString(tokenType: TokenType.muteUser);
final String likeReplyTokenType = returnTokenTypeString(tokenType: TokenType.likeReply);
final String searchHistoryTokenType = returnTokenTypeString(tokenType: TokenType.searchHistory);
final String readPostTokenType = returnTokenTypeString(tokenType: TokenType.readPost);
// tokenType(notification)
final String authNotificationType = returnNotificationTypeString(notifcationType: NotificationType.authNotification);
final String officialNotificationType = returnNotificationTypeString(notifcationType: NotificationType.officialNotification);
final String commentNotificationType = returnNotificationTypeString(notifcationType: NotificationType.commentNotification);
final String replyNotificationType = returnNotificationTypeString(notifcationType: NotificationType.replyNotification );
// fieldKey
const String bookmarksFieldKey = 'bookmarks';
const String bookmarkLabelIdFieldKey = 'bookmarkLabelId';
const String createdAtFieldKey = 'createdAt';
const String elementIdFieldKey = 'elementId';
const String followerUidsFieldKey = 'followerUids';
const String followerCountFieldKey = 'followerCount';
const String replyIdFieldKey = 'replyId';
const String likeCountFieldKey = 'likeCount';
const String officialAdsensesFieldKey = 'officialAdsenses';
const String commentNotificationsFieldKey = 'commentNotifications';
const String followersFieldKey = 'followers';
const String replyNotificationsFieldKey = 'replyNotifications';
const String timelinesFieldKey = 'timelines';
const String commentsFieldKey = 'comments';
const String likesFieldKey = 'likes';
const String scoreFieldKey = 'score';
const String isReadFieldKey = 'isRead';
const String postsFieldKey = 'posts';
const String replysFieldKey = 'replys';
const String uidFieldKey = 'uid';
const String userMetaFieldKey = 'userMeta';
const String usersFieldKey = 'users';
const String postIdFieldKey = 'postId';
const String tokenTypeFieldKey = 'tokenType';
const String tokenToSearchFieldKey = 'tokenToSearch';
const String numberFieldKey = 'number';
const String nftOwnersFieldKey = 'nftOwners';
const String updatedAtFieldKey = 'updatedAt';
const String passiveUidFieldKey = 'passiveUid';
const String notificationsFieldKey = 'notifications';
const String notificationTypeFieldKey = 'notificationType';
// path
const String postImagesPathKey = 'postImages';
const String userImagesPathKey = 'userImages';
// mapKey
const String ipv6MapKey = 'ipv6';
const String tokenTypeMapKey = 'tokenType';
const String notificationTypeMapKey = 'notificationType';
const String uidMapKey = 'uid';
