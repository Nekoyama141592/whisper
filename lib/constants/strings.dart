// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
// packages
import 'package:uuid/uuid.dart';
// domain
import 'package:whisper/domain/user_meta/user_meta.dart';

const String hyphenString = '-';
final String uuid4 = Uuid().v4();
const String tokenString = 'token';
const String postExtension = '.aac';
const String imageExtension = '.jpeg';
const String unNamedString = 'unNamed';
const String notificationString = 'notification';
const String recommendableString = 'recommendable';
const String onlyFollowingAndFollowedString = 'onlyFollowingAndFollowed';

String returnStorageUserImageName() {
  return 'userImageStorage' + hyphenString + uuid4 + hyphenString + imageExtension;
}
String returnStoragePostImageName() {
  return 'postImageStorage' + hyphenString + uuid4 + hyphenString + imageExtension;
}
final String returnStoragePostName = 'postStorage' + hyphenString + uuid4 + hyphenString + postExtension;

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
// prefs
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
// colRefName
const String usersColRefName = 'users';
const String userMetaColRefName = 'userMeta';
const String followersColRefName = 'followers';
const String tokensColRefName = 'tokens';
const String notificationsColRefName = 'notifications';
const String postsColRefName = 'posts';
const String postLikesColRefName = 'postLikes';
const String postBookmarksColRefName = 'postBookmarks';
const String postCommentsColRefName = 'postComments';
const String postCommentLikesColRefName = 'postCommentLikes';
const String postCommentReplysColRefName = 'postCommentReplys';
const String postCommentReplyLikesColRefName = 'postCommentReplyLikes';
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
const String searchTokenFieldKey = 'searchToken';
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
const String tokenTypeMapKey = 'tokenType'; // lib/constants/enums.dart
const String notificationTypeMapKey = 'notificationType'; // lib/constants/enums.dart
