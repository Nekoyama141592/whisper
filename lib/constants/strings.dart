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
// keys
const String accountNameKey = 'accountName';
const String audioURLKey = 'audioURL';
const String authNotificationsKey = 'authNotifications';
const String birthDayKey = 'birthDay';
const String blocksIpv6AndUidsKey = 'blocksIpv6AndUids';
const String bookmarkCountKey = 'bookmarkCount';
const String bookmarksKey = 'bookmarks';
const String commentIdKey = 'commentId';
const String commentKey = 'comment';
const String commentCountKey = 'commentCount';
const String commentsKey = 'comments';
const String commentScoreKey = 'commentScore';
const String commentNotificationsKey = 'commentNotifications';
const String commentsStateKey = 'commentsState';
const String createdAtKey = 'createdAt';
const String countryKey = 'country';
const String descriptionKey = 'description';
const String dmStateKey = 'dmState';
const String durationIntKey = 'durationInt';
const String elementIdKey = 'elementId';
const String elementStateKey = 'elementState';
const String followingUidsKey = 'followingUids';
const String followersKey = 'followers';
const String followerCountKey = 'followerCount';
const String followerUidKey = 'followerUid';
const String genderKey = 'gender';
const String genreKey = 'genre';
const String hashTagsKey = 'hashTags';
const String ipv6Key = 'ipv6';
const String imageURLKey = 'imageURL';
const String impressionKey = 'impression';
const String isAdminKey = 'isAdmin';
const String isDeleteKey = 'isDelete';
const String isKeyAccountKey = 'isKeyAccount';
const String isNFTiconKey = 'isNFTicon';
const String isOfficialKey = 'isOfficial';
const String isPinnedKey = 'isPinned';
const String languageKey = 'language';
const String mutesIpv6AndUidsKey = 'mutesIpv6AndUids';
const String negativeScoreKey = 'negativeScore';
const String nftOwnersKey = 'nftOwners';
const String noDisplayIpv6AndUidsKey = 'noDisplayIpv6AndUids';
const String noDisplayWordsKey = 'noDisplayWords';
const String notificationIdKey = 'notificationId';
const String numberKey = 'number';
const String likeCountKey = 'likeCount';
const String officialAdsensesKey = 'officialAdsenses';
const String otherLinksKey = 'otherLinks';
const String readPostsKey = 'readPosts';
const String passiveUidKey = 'passiveUid';
const String playCountKey = 'playCount';
const String positiveScoreKey = 'positiveScore';
const String postsKey = 'posts';
const String postIdKey = 'postId';
const String postImagesKey = 'postImages';
const String postTitleKey = 'postTitle';
const String recommendStateKey = 'recommendState';
const String replyKey = 'reply';
const String replyNotificationsKey = 'replyNotifications';
const String replyScoreKey = 'replyScore';
const String replysKey = 'replys';
const String replyCountKey = 'replyCount';
const String replyIdKey = 'replyId';
const String scoreKey = 'score';
const String searchHistoryKey = 'searchHistory';
const String storageImageNameKey = 'storageImageName';
const String storagePostNameKey = 'storagePostName';
const String tagUidsKey = 'tagUids';
const String tokenToSearchKey = 'tokenToSearch';
const String titleKey = 'title';
const String uidKey = 'uid';
const String updatedAtKey = 'updatedAt';
const String userImagesKey = 'userImages';
const String userImageURLKey = 'userImageURL';
const String userMetaKey = 'userMeta';
const String userNameKey = 'userName';
const String usersKey = 'users';
// strings
const String bookmarkLabelString = 'bookmarkLabel';
const String bookmarkLabelsString = 'bookmarkLabels';
const String tokenString = 'token';
const String tokensString = 'tokens';
const String unNamedString = 'unNamed';
// prefs
const String bookmarkPostIdsPrefsKey = 'bookmarkPostIds';
const String likePostIdsPrefsKey = 'likePostIds';
const String likeCommentIdsPrefsKey = 'likeCommentIds';
const String likeReplyIdsPrefsKey = 'likeReplyIds';
const String readPostIdsPrefsKey = 'readPostIds';
const String speedPrefsKey = 'speed';
