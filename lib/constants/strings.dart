// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
// packages
import 'package:uuid/uuid.dart';
// domain
import 'package:whisper/domain/user_meta/user_meta.dart';

const String postExtension = '.aac';
const String imageExtension = '.jpeg';
const String onlyFollowingAndFollowedString = 'onlyFollowingAndFollowed';
const String recommendableString = 'recommendable';
final String hyphenString = '-';
final String uuid4 = Uuid().v4();

String returnStorageUserImageName() {
  return 'userImageStorage' + hyphenString + uuid4 + hyphenString + imageExtension;
}
String returnStoragePostImageName() {
  return 'postImageStorage' + hyphenString + uuid4 + hyphenString + imageExtension;
}
final String returnStoragePostName = 'postSorage' + hyphenString + uuid4 + hyphenString + postExtension;


String returnPostId({ required UserMeta userMeta }) {
  return 'post' + hyphenString + userMeta.uid + hyphenString + uuid4;
}

String returnTokenId({required UserMeta userMeta,required TokenType tokenType }) {
  return returnTokenTypeString(tokenType: tokenType) + hyphenString + userMeta.uid + uuid4 ;
}
String returnTokenTypeString({ required TokenType tokenType } ) {
  return tokenType.toString().substring(tokenTypeStartIndex);
}
String returnNotificationId({ required NotificationType notificationType}) {
  return returnNotificationTypeString(notificationType: notificationType) + hyphenString + uuid4;
}
String returnNotificationTypeString({ required NotificationType notificationType }) {
  return notificationType.toString().substring(notificationTypeStartIndex);
}
String generatePostCommentId({ required String uid }) {
  return 'postComment' + hyphenString + uid + hyphenString + uuid4;
}
String generatePostCommentReplyId({ required String uid }) {
  return 'postCommentReply' + hyphenString + uid + hyphenString + uuid4;
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
final String authNotificationType = returnNotificationTypeString(notificationType: NotificationType.authNotification);
final String officialNotificationType = returnNotificationTypeString(notificationType: NotificationType.officialNotification);
final String commentNotificationType = returnNotificationTypeString(notificationType: NotificationType.commentNotification);
final String replyNotificationType = returnNotificationTypeString(notificationType: NotificationType.replyNotification );
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
const String likesFieldKey = 'likes';
const String scoreFieldKey = 'score';
const String isReadFieldKey = 'isRead';
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
const String postPathKey = 'posts';
// mapKey
const String ipv6MapKey = 'ipv6';
const String tokenTypeMapKey = 'tokenType';
const String notificationTypeMapKey = 'notificationType';
const String uidMapKey = 'uid';
