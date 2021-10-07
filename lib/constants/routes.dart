// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// pages
import 'package:whisper/main.dart';
import 'package:whisper/auth/login/login_page.dart';
import 'package:whisper/auth/signup/signup_page.dart';
import 'package:whisper/components/bookmarks/bookmarks_page.dart';
import 'package:whisper/posts/components/other_pages/post_show/post_show_page.dart';
import 'package:whisper/components/user_show/user_show_page.dart';
import 'package:whisper/auth/verify/verify_page.dart';
import 'package:whisper/admin/admin_page.dart';
import 'package:whisper/auth/account/account_page.dart';
import 'package:whisper/components/notifications/notifications_page.dart';
import 'package:whisper/components/add_post/add_post_page.dart';
import 'package:whisper/auth/update_password/update_password_page.dart';
import 'package:whisper/auth/reauthentication/reauthentication_page.dart';
import 'package:whisper/auth/verify_password_reset/verify_password_reset_page.dart';
import 'package:whisper/auth/update_email/update_email_page.dart';
import 'package:whisper/components/add_post/other_pages/pick_post_image_page.dart';
import 'package:whisper/posts/components/comments/comments_page.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/account_model.dart';
import 'package:whisper/themes/themes_model.dart';
import 'package:whisper/components/add_post/add_post_model.dart';

void toMyApp(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
}
void toLoginpage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

void toSignupPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
}

void toVerifyPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyPage()));
}
void toVerifyPasswordResetPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyPasswordResetPage()));
}

void toUpdateEmailPage(context,User? currentUser) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEmailPage(currentUser: currentUser,)));
}
void toUpdatePassword(context,User? currentUser) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePasswordPage(currentUser: currentUser,)));
}
void toReauthenticationPage(context,User? currentUser,AccountModel accountModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => ReauthenticationPage(currentUser: currentUser,accountModel: accountModel,)));
}

void toBookmarksPage(context,DocumentSnapshot currentUserDoc,List<dynamic> bookmarkedPostIds,List<dynamic> likedPostIds,List<dynamic> likedCommentIds,List<dynamic> likedComments,List<dynamic> bookmarks,List<dynamic> likes) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarksPage(currentUserDoc: currentUserDoc, bookmarkedPostIds: bookmarkedPostIds, likedPostIds: likedPostIds,likedCommentIds: likedCommentIds,likedComments: likedComments,bookmarks: bookmarks,likes: likes,) ));
}

void toPostShowPage(context,List<dynamic> likedPostIds,List<dynamic> bookmarkedPostIds,List<dynamic> likedCommentIds,List<dynamic> likedComments, List<dynamic> bookmarks,List<dynamic> likes,DocumentSnapshot currentUserDoc, ValueNotifier<DocumentSnapshot?> currentSongDocNotifier,ProgressNotifier progressNotifier,void Function(Duration)? seek,RepeatButtonNotifier repeatButtonNotifier,void Function()? onRepeatButtonPressed,ValueNotifier<bool> isFirstSongNotifier,void Function()?  onPreviousSongButtonPressed,PlayButtonNotifier playButtonNotifier,void Function()? play,void Function()? pause,ValueNotifier<bool> isLastSongNotifier,void Function()? onNextSongButtonPressed) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PostShowPage(likedPostIds: likedPostIds, bookmarkedPostIds: bookmarkedPostIds, likedCommentIds: likedCommentIds, likedComments: likedComments, bookmarks: bookmarks, likes: likes, currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, progressNotifier: progressNotifier, seek: seek, repeatButtonNotifier: repeatButtonNotifier, onRepeatButtonPressed: onRepeatButtonPressed, isFirstSongNotifier: isFirstSongNotifier, onPreviousSongButtonPressed: onPreviousSongButtonPressed, playButtonNotifier: playButtonNotifier, play: play, pause: pause, isLastSongNotifier: isLastSongNotifier, onNextSongButtonPressed: onNextSongButtonPressed) ));
}

void toUserShowPage(context,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc,List<dynamic> bookmarkedPostIds,List<dynamic> likedPostIds,List<dynamic> followingUids, List<dynamic> likedCommentIds,List<dynamic> likedComments,List<dynamic> bookmarks,List<dynamic> likes) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage(currentUserDoc: currentUserDoc, passiveUserDoc: passiveUserDoc, bookmarkedPostIds: bookmarkedPostIds, likedPostIds: likedPostIds, followingUids: followingUids,likedCommentIds: likedCommentIds,likedComments: likedComments,bookmarks: bookmarks,likes: likes,) ));
}
void toAdminPage(context,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage(currentUserDoc: currentUserDoc) ));
}

void toAccountPage(context,DocumentSnapshot currentUserDoc,User? currentUser) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(currentUserDoc: currentUserDoc)));
}

void toNotificationsPage(context,MainModel mainModel,ThemeModel themeModel,List<dynamic> bookmarkedPostIds,List<dynamic> likedPostIds,List<dynamic> replyNotifications,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(mainModel: mainModel, themeModel: themeModel, bookmarkedPostIds: bookmarkedPostIds, likedPostIds: likedPostIds,replyNotifications: replyNotifications,currentUserDoc: currentUserDoc,) ));
}

void toAddPostPage (context,AddPostModel addPostModel,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage(currentUserDoc: currentUserDoc, addPostModel: addPostModel) ));
}

void toPickPostImagePage(context,AddPostModel addPostModel, DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PickPostImagePage(addPostModel: addPostModel, currentUserDoc: currentUserDoc) ));
}

void toCommentsPage(context,List<dynamic> likedCommentIds, List<dynamic> likedComments,ValueNotifier<DocumentSnapshot?> currentSongDocNotifier,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(likedCommentIds: likedCommentIds,likedComments: likedComments,currentSongDoc: currentSongDocNotifier.value!,currentUserDoc: currentUserDoc,) ));
}


