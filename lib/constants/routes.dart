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
import 'package:whisper/components/home/feeds/components/feed_show_page.dart';
import 'package:whisper/components/home/recommenders/components/recommender_show_page.dart';
import 'package:whisper/components/user_show/components/details/user_show_post_show_page.dart';
import 'package:whisper/components/user_show/user_show_page.dart';
import 'package:whisper/components/bookmarks/components/bookmark_show_page.dart';
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
import 'package:whisper/posts/components/other_pages/edit_post_info/edit_post_info_page.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/account_model.dart';
import 'package:whisper/components/bookmarks/bookmarks_model.dart';
import 'package:whisper/components/home/feeds/feeds_model.dart';
import 'package:whisper/components/home/recommenders/recommenders_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
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

void toBookmarksPage(context,DocumentSnapshot currentUserDoc,List<dynamic> preservatedPostIds,List<dynamic> likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarksPage(currentUserDoc,preservatedPostIds,likedPostIds)));
}

void toBookmarksShowPage(context,DocumentSnapshot currentUserDoc,BookMarksModel bookmarksModel,List<dynamic> preservatedPostIds,List<dynamic> likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarkShowPage(currentUserDoc: currentUserDoc, bookmarksModel: bookmarksModel, preservatedPostIds: preservatedPostIds, likedPostIds: likedPostIds) ));
}

void toUserShowPage(context,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc,List<dynamic> preservatedPostIds,List<dynamic> likedPostIds,List<dynamic> followingUids) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage(currentUserDoc,passiveUserDoc,preservatedPostIds,likedPostIds,followingUids)));
}
void toFeedShowPage(context,FeedsModel feedsModel,List<dynamic> preservatedPostIds,List<dynamic> likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedShowPage(feedsModel: feedsModel, preservatedPostIds: preservatedPostIds, likedPostIds: likedPostIds) ));
}

void toRecommenderShowPage(context,DocumentSnapshot currentUserDoc,RecommendersModel recommendersModel,List<dynamic> preservatedPostIds,List<dynamic> likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => RecommenderShowPage(currentUserDoc: currentUserDoc, recommendersModel: recommendersModel, preservatedPostIds: preservatedPostIds, likedPostIds: likedPostIds) ));
}

void toUserShowPostShowPage(context,DocumentSnapshot currentUserDoc,UserShowModel userShowModel,List<dynamic> preservatedPostIds,List<dynamic> likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPostShowPage(currentUserDoc: currentUserDoc, userShowModel: userShowModel, preservatedPostIds: preservatedPostIds, likedPostIds: likedPostIds) ));
}

void toAdminPage(context,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage(currentUserDoc)));
}

void toAccountPage(context,DocumentSnapshot currentUserDoc,User? currentUser) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(currentUserDoc: currentUserDoc)));
}

void toNotificationsPage(context,MainModel mainModel,ThemeModel themeModel,List<dynamic> preservatedPostIds,List<dynamic> likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(mainModel, themeModel, preservatedPostIds, likedPostIds) ));
}

void toAddPostPage (context,AddPostModel addPostModel,DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage(currentUserDoc: currentUserDoc, addPostModel: addPostModel) ));
}

void toPickPostImagePage(context,AddPostModel addPostModel, DocumentSnapshot currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PickPostImagePage(addPostModel: addPostModel, currentUserDoc: currentUserDoc) ));
}

void toEditPostInfoPage(context,DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => EditPostInfoPage(currentUserDoc: currentUserDoc, currentSongDoc: currentSongDoc) ));
}

