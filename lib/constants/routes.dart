// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
// pages
import 'package:whisper/main.dart';
import 'package:whisper/auth/login/login_page.dart';
import 'package:whisper/auth/signup/signup_page.dart';
import 'package:whisper/components/bookmarks/bookmarks_page.dart';
import 'package:whisper/posts/components/other_pages/post_show/post_show_page.dart';
import 'package:whisper/components/user_show/user_show_page.dart';
import 'package:whisper/auth/signup/other_pages/add_user_info_page.dart';
import 'package:whisper/auth/verify/verify_page.dart';
import 'package:whisper/admin/admin_page.dart';
import 'package:whisper/auth/account/account_page.dart';
import 'package:whisper/components/notifications/notifications_page.dart';
import 'package:whisper/components/add_post/add_post_page.dart';
import 'package:whisper/auth/update_password/update_password_page.dart';
import 'package:whisper/auth/reauthentication/reauthentication_page.dart';
import 'package:whisper/auth/login/verify_password_reset/verify_password_reset_page.dart';
import 'package:whisper/auth/update_email/update_email_page.dart';
import 'package:whisper/components/add_post/other_pages/pick_post_image_page.dart';
import 'package:whisper/posts/components/comments/comments_page.dart';
import 'package:whisper/auth/account/other_pages/mutes_users/mutes_users_page.dart';
import 'package:whisper/auth/account/other_pages/blocking_users/blocking_users_page.dart';
import 'package:whisper/auth/is_finished/is_finished_page.dart';
import 'package:whisper/important_matters/other_pages/compliance_page.dart';
import 'package:whisper/important_matters/other_pages/privacy_page.dart';
import 'package:whisper/important_matters/other_pages/tos_page.dart';
import 'package:whisper/important_matters/important_matters_page.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/account_model.dart';
import 'package:whisper/themes/themes_model.dart';
import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/auth/signup/signup_model.dart';

void toMyApp(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
}
void toLoginpage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

void toSignupPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
}

void toAddUserInfoPage(context,SignupModel signupModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddUserInfoPage(signupModel: signupModel)));
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
void toReauthenticationPage(context,User? currentUser,AccountModel accountModel,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => ReauthenticationPage(currentUser: currentUser,accountModel: accountModel,currentUserDoc: currentUserDoc,)));
}

void toBookmarksPage(context,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarksPage(mainModel: mainModel) ));
}

void toPostShowPage(context,ValueNotifier<double> speedNotifier,void Function()? speedControll,ValueNotifier<DocumentSnapshot?> currentSongDocNotifier,ProgressNotifier progressNotifier,void Function(Duration)? seek,RepeatButtonNotifier repeatButtonNotifier,void Function()? onRepeatButtonPressed,ValueNotifier<bool> isFirstSongNotifier,void Function()? onPreviousSongButtonPressed,PlayButtonNotifier playButtonNotifier,void Function()? play,void Function()? pause,ValueNotifier<bool> isLastSongNotifier,void Function()? onNextSongButtonPressed,void Function()? toCommentsPage,void Function()? toEditingMode,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) =>PostShowPage(speedNotifier: speedNotifier, speedControll: speedControll, currentSongDocNotifier: currentSongDocNotifier, progressNotifier: progressNotifier, seek: seek, repeatButtonNotifier: repeatButtonNotifier, onRepeatButtonPressed: onRepeatButtonPressed, isFirstSongNotifier: isFirstSongNotifier, onPreviousSongButtonPressed: onPreviousSongButtonPressed, playButtonNotifier: playButtonNotifier, play: play, pause: pause, isLastSongNotifier: isLastSongNotifier, onNextSongButtonPressed: onNextSongButtonPressed, toCommentsPage: toCommentsPage, toEditingMode: toEditingMode, mainModel: mainModel) ));
}

void toUserShowPage(context,DocumentSnapshot passiveUserDoc,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage(passiveUserDoc: passiveUserDoc, mainModel: mainModel)));
}
void toAdminPage(context,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage(currentUserDoc: currentUserDoc) ));
}

void toAccountPage(context,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(mainModel: mainModel,)));
}

void toNotificationsPage(context,MainModel mainModel,ThemeModel themeModel,List<dynamic> bookmarkedPostIds,List<dynamic> likedPostIds,List<dynamic> replyNotifications,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(mainModel: mainModel, themeModel: themeModel, bookmarkedPostIds: bookmarkedPostIds, likedPostIds: likedPostIds,replyNotifications: replyNotifications,currentUserDoc: currentUserDoc) ));
}

void toAddPostPage (context,AddPostModel addPostModel,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage(currentUserDoc: currentUserDoc, addPostModel: addPostModel) ));
}

void toPickPostImagePage(context,AddPostModel addPostModel, DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PickPostImagePage(addPostModel: addPostModel, currentUserDoc: currentUserDoc) ));
}

void toCommentsPage(context, void Function()? showSortDialogue,AudioPlayer audioPlayer,ValueNotifier<List<dynamic>> currentSongMapCommentsNotifier,ValueNotifier<DocumentSnapshot?> currentSongDocNotifier,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(showSortDialogue: showSortDialogue,audioPlayer: audioPlayer, currentSongMapCommentsNotifier: currentSongMapCommentsNotifier, currentSongDoc: currentSongDocNotifier.value!, mainModel: mainModel) ));
}

void toBlockingUsersPage(context, MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => BlockingUsersPage(mainModel: mainModel,) ));
}

void toMutesUsersPage(context,MainModel mainModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MutesUsersPage(mainModel: mainModel,) ));
}

void toIsFinishedPage(context,String text) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => IsFinishedPage(text: text,) ));
}

void toCompliancePage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => CompliancePage() ));
}

void toPrivacyPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPage() ));
}

void toTosPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => TosPage() ));
}

void toImportantMattersPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => ImportantMattersPage() ));
}


