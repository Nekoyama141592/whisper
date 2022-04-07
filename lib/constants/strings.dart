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

String returnStorageUserImageName() => 'userImageStorage' + hyphenString + returnUuid4()+ imageExtension;

String returnStoragePostImageName() => 'postImageStorage' + hyphenString + returnUuid4() + imageExtension;

String returnStoragePostName() => 'postStorage' + hyphenString + returnUuid4()+ postExtension;

String returnJaInt({ required int count }) => count >= 10000 ? (count/1000.floor()/10).toString() + '万' :  count.toString();

String returnPostId({ required UserMeta userMeta }) => 'post' + hyphenString + userMeta.uid + hyphenString + returnUuid4();

String returnOfficialAdvertisementImpressionId({ required String uid }) => 'officialAdvertisementImpression' + hyphenString + uid + hyphenString + returnUuid4();

String returnUuid4() => Uuid().v4();

String returnTokenId({required UserMeta userMeta,required TokenType tokenType }) => returnTokenTypeString(tokenType: tokenType) + hyphenString + userMeta.uid + returnUuid4();

String returnTokenTypeString({ required TokenType tokenType } ) => tokenType.toString().substring(tokenTypeStartIndex);

String returnNotificationId({ required NotificationType notificationType}) => returnNotificationTypeString(notificationType: notificationType) + hyphenString + returnUuid4();

String returnNotificationTypeString({ required NotificationType notificationType }) => notificationType.toString().substring(notificationTypeStartIndex);

String returnDmStateString({ required DmState dmState }) => dmState.toString().substring(dmStateStartIndex);

String returnRecommendStateString ({ required RecommendState recommendState }) => recommendState.toString().substring(recommendStateStartIndex);

String returnPostStateString ({ required PostState postState }) => postState.toString().substring(postStateStartIndex);

String returnCommentsStateString ({ required CommentsState commentsState }) => commentsState.toString().substring(commentsStateStartIndex);

String returnGenderString({ required Gender gender }) => gender.toString().substring(genderStartIndex);

String returnReportContentString({ required List<String> selectedReportContents }) {
  String reportContentString = '';
  for (final i in selectedReportContents) {
    reportContentString += '・';
    reportContentString += i;
    reportContentString += ',';
  }
  return reportContentString;
}

String generatePostCommentId({ required String uid }) => 'postComment' + hyphenString + uid + hyphenString + returnUuid4();

String generatePostCommentReplyId({ required String uid }) => 'postCommentReply' + hyphenString + uid + hyphenString + returnUuid4();

String generateUserUpdateLogId() => 'userUpdateLog' + hyphenString + returnUuid4();

String generateUserMetaUpdateLogId() => 'userMetaUpdateLog' + hyphenString + returnUuid4();

String generatePostUpdateLogId() => 'postUpdateLog' + hyphenString + returnUuid4();

String generateUserUpdateLogNoBatchId() => 'userUpdateLogNoBatch' + hyphenString + returnUuid4();

String generatePostReportId() => 'postReport' + hyphenString + returnUuid4();

String generatePostCommentReportId() => 'postCommentReport'  + hyphenString + returnUuid4();

String generatePostCommentReplyReportId() => 'postCommentReplyReport' + hyphenString + returnUuid4();

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
const String userMutesColRefName = 'userMutes';
const String userUpdateLogsColRefName = 'userUpdateLogs';
const String userUpdateLogNoBatchesColRefName = 'userUpdateLogNoBatches';
const String userMetaUpdateLogsColRefName = 'userMetaUpdateLogs';
const String userMetaColRefName = 'userMeta';
const String followersColRefName = 'followers';
const String tokensColRefName = 'tokens';
const String notificationsColRefName = 'notifications';
const String postsColRefName = 'posts';
const String postUpdateLogsColRefName = 'postUpdateLogs';
const String postLikesColRefName = 'postLikes';
const String postBookmarksColRefName = 'postBookmarks';
const String postCommentsColRefName = 'postComments';
const String postCommentLikesColRefName = 'postCommentLikes';
const String postCommentRepliesColRefName = 'postCommentReplies';
const String postCommentReplyLikesColRefName = 'postCommentReplyLikes';
const String officialAdvertisementsColRefName = 'officialAdvertisements';
const String officialAdvertisementImperssionsColRefName = 'officialAdvertisementImpressions';
const String officialAdvertisementConfigColRefName = 'officialAdvertisementConfig';
const String postReportsColRefName = 'postReports';
const String postCommentReportsColRefName = 'postCommentReports';
const String postCommentReplyReportsColRefName = 'postCommentReplyReports';
const String postMutesColRefName = 'postMutes';
const String postCommentMutesColRefName = 'postCommentMutes';
const String postCommentReplyMutesColRefName = 'postCommentReplyMutes';
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
const String postsPathKey = 'posts';
// mapKey
const String isReadMapKey = 'isRead';
const String tokenTypeMapKey = 'tokenType'; // lib/constants/enums.dart
const String notificationTypeMapKey = 'notificationType'; // lib/constants/enums.dart
const String uidMapKey = 'uid'; // lib/posts/components/comments_or_replys/comments_or_replys_model.dart
// urls
const String privacyURL = 'https://whisper-web.herokuapp.com/privacy';
const String complianceURL = 'https://whisper-web.herokuapp.com/compliance';
const String tosURL = 'https://whisper-web.herokuapp.com/tos';
// msg
const String muteUserMsg = 'ユーザーをミュートしました';
const String mutePostMsg = 'この投稿をミュートしました';
const String mutePostCommentMsg = 'このコメントをミュートしました';
const String mutePostCommentReplyMsg = 'このリプライをミュートしました';
const String emptyMsg = 'キャンセルされました';
const String pleaseScrollMsg = '上にスクロールすると表示されます';
final String maxCommentOrReplyMsg = maxCommentOrReplyLength.toString() + '以下でお願いします'; 
const String reportPostMsg = '投稿をを報告しました';
const String reportUserMsg = 'ユーザーを報告しました';
const String reportPostCommentMsg = 'コメントを報告しました';
const String reportPostCommentReplyMsg = 'リプライを報告しました';
const String pleaseInputTitleMsg = 'タイトルを入力してください';
const String cannotCommentMsg = 'コメントは投稿主しかできません';
const String cannotReplyMsg = 'あなたはこのコメントに返信できません';
const String dontHaveRightMsg = 'あなたにその権限はありません';
const String reflectChangesJaMsg = 'いいねボタンや目のボタンを押すと反映されます';
// Id
const String configIdString = 'config';
// title
const String reportTitle = '問題を報告してください';
// text
const String okText = 'OK';
const String decideModalMsg = '決定';
const String sendModalMsg = '送信';
const String cancelText = 'キャンセル';
const String muteUserJaText = 'ユーザーをミュート';
const String mutePostJaText = '投稿をミュート';
const String muteCommentJaText = 'コメントをミュート';
const String muteReplyJaText = 'リプライをミュート';
const String reportPostJaText = '投稿を報告';
const String reportCommentJaText = 'コメントを報告';
const String reportReplyJaText = 'リプライを報告';
const String deletePostText = '自分の投稿を完全に削除';
const String deleteCommentJaText = '自分のコメントを完全に削除';
const String deleteReplyJaText = '自分のリプライを完全に削除';
const String sortJaText = '並び替え';
const String sortCommentJaText = 'コメントを並び替えます';
const String sortReplyJaText = 'リプライを並び替えます';
const String sortByLikeUidCountText = 'いいね順';
const String sortByNewestFirstText = '新しい順';
const String sortByOldestFirstText = '古い順';
const String inputCommentText = 'コメントを入力';
const String inputReplyText = 'リプライを入力';
const String commentsStateText = 'コメントの状態';
const String configCommentsStateText = 'コメントの状態を設定します';
const String commentsStateIsOpenText = '誰でもコメント可能';
const String commentsStateIsLockedText = '自分以外コメント不可能';