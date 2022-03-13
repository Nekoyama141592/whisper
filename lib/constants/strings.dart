// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
// packages
import 'package:uuid/uuid.dart';
// domain
import 'package:whisper/domain/user_meta/user_meta.dart';

const String hyphenString = '-';
const String tokenString = 'token';
const String postExtension = '.aac';
const String imageExtension = '.jpeg';
const String unNamedString = 'unNamed';
const String notificationString = 'notification';
const String recommendableString = 'recommendable';
const String onlyFollowingAndFollowedString = 'onlyFollowingAndFollowed';

String returnStorageUserImageName() {
  return 'userImageStorage' + hyphenString + returnUuid4()+ imageExtension;
}
String returnStoragePostImageName() {
  return 'postImageStorage' + hyphenString + returnUuid4() + imageExtension;
}
String returnStoragePostName() {
  return 'postStorage' + hyphenString + returnUuid4()+ postExtension;
} 
String returnPostId({ required UserMeta userMeta }) {
  return 'post' + hyphenString + userMeta.uid + hyphenString + returnUuid4();
}

String returnOfficialAdvertisementImpressionId({ required String uid }) {
  return 'officialAdvertisementImpression' + hyphenString + uid + hyphenString + returnUuid4();
}

String returnOfficialAdvertisementTapId({ required String uid }) {
  return 'officialAdvertisementTap' + hyphenString + uid + hyphenString + returnUuid4();
}

String returnUuid4() {
  return Uuid().v4();
}

String returnTokenId({required UserMeta userMeta,required TokenType tokenType }) {
  return returnTokenTypeString(tokenType: tokenType) + hyphenString + userMeta.uid + returnUuid4();
}
String returnTokenTypeString({ required TokenType tokenType } ) {
  return tokenType.toString().substring(tokenTypeStartIndex);
}
String returnNotificationId({ required NotificationType notificationType}) {
  return returnNotificationTypeString(notificationType: notificationType) + hyphenString + returnUuid4();
}
String returnNotificationTypeString({ required NotificationType notificationType }) {
  return notificationType.toString().substring(notificationTypeStartIndex);
}
String generatePostCommentId({ required String uid }) {
  return 'postComment' + hyphenString + uid + hyphenString + returnUuid4();
}
String generatePostCommentReplyId({ required String uid }) {
  return 'postCommentReply' + hyphenString + uid + hyphenString + returnUuid4();
}
String generateUserUpdateLogId() {
  return 'userUpdateLog' + hyphenString + returnUuid4();
}
// prefs
const String speedPrefsKey = 'speed';
const String isDarkThemePrefsKey = 'isDarkTheme';
// tokenTypes
final String blockUserTokenType = returnTokenTypeString(tokenType: TokenType.blockUser);
final String bookmarkPostCategoryTokenType = returnTokenTypeString(tokenType: TokenType.bookmarkPostCategory);
final String bookmarkPostTokenType = returnTokenTypeString(tokenType: TokenType.bookmarkPost);
final String followingTokenType = returnTokenTypeString(tokenType: TokenType.following);
final String likePostTokenType = returnTokenTypeString(tokenType: TokenType.likePost);
final String likePostCommentTokenType = returnTokenTypeString(tokenType: TokenType.likePostComment);
final String watchlistTokenType = returnTokenTypeString(tokenType: TokenType.watchlist);
final String mutePostCommentTokenType = returnTokenTypeString(tokenType: TokenType.mutePostComment);
final String mutePostTokenType = returnTokenTypeString(tokenType: TokenType.mutePost);
final String mutePostCommentReplyTokenType = returnTokenTypeString(tokenType: TokenType.mutePostCommentReply);
final String muteUserTokenType = returnTokenTypeString(tokenType: TokenType.muteUser);
final String likePostCommentReplyTokenType = returnTokenTypeString(tokenType: TokenType.likePostCommentReply);
final String searchHistoryTokenType = returnTokenTypeString(tokenType: TokenType.searchHistory);
final String readPostTokenType = returnTokenTypeString(tokenType: TokenType.readPost);
// tokenType(notification)
final String authNotificationType = returnNotificationTypeString(notificationType: NotificationType.authNotification);
final String officialNotificationType = returnNotificationTypeString(notificationType: NotificationType.officialNotification);
final String commentNotificationType = returnNotificationTypeString(notificationType: NotificationType.postCommentNotification);
final String replyNotificationType = returnNotificationTypeString(notificationType: NotificationType.postCommentReplyNotification );
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
const String postCommentRepliesColRefName = 'postCommentReplies';
const String postCommentReplyLikesColRefName = 'postCommentReplyLikes';
const String officialAdvertisementsColRefName = 'officialAdvertisements';
const String officialAdvertisementImperssionsColRefName = 'officialAdvertisementImpressions';
const String officialAdvertisementTapsColRefName = 'officialAdvertisementTaps';
const String officialAdvertisementConfigColRefName = 'officialAdvertisementConfig';
// fieldKey
const String bookmarksFieldKey = 'bookmarks';
const String createdAtFieldKey = 'createdAt';
const String followerUidsFieldKey = 'followerUids';
const String followerCountFieldKey = 'followerCount';
const String replyIdFieldKey = 'replyId';
const String likeCountFieldKey = 'likeCount';
const String officialAdvertisementsFieldKey = 'officialAdvertisements';
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
const String postIdFieldKey = 'postId'; // lib/components/bookmarks/bookmarks_model.dart
const String tokenTypeFieldKey = 'tokenType';
const String searchTokenFieldKey = 'searchToken';
const String numberFieldKey = 'number';
const String nftOwnersFieldKey = 'nftOwners';
const String updatedAtFieldKey = 'updatedAt';
const String passiveUidFieldKey = 'passiveUid';
const String notificationsFieldKey = 'notifications';
const String notificationTypeFieldKey = 'notificationType';
const String userUpdateLogsFieldKey = 'userUpdateLogs';
// updateFieldKey
const String imageURLsFieldKey = 'imageURLs';
const String imageURLFieldKey = 'imageURL';
const String titleFieldKey = 'title';
const String linksFieldKey = '';
const String followingCountFieldKey = '';
const String userNameFieldKey = 'userName';
const String postCountFieldKey = 'postCount';
// path
const String postImagesPathKey = 'postImages';
const String userImagesPathKey = 'userImages';
const String postPathKey = 'posts';
// mapKey
const String isReadMapKey = 'isRead';
const String tokenTypeMapKey = 'tokenType'; // lib/constants/enums.dart
const String notificationTypeMapKey = 'notificationType'; // lib/constants/enums.dart
// urls
const String privacyURL = 'https://whisper-web.herokuapp.com/privacy';
const String complianceURL = 'https://whisper-web.herokuapp.com/compliance';
const String tosURL = 'https://whisper-web.herokuapp.com/tos';