import 'package:flutter/material.dart';

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

void toUpdateEmailPage(context,currentUser) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateEmailPage(currentUser: currentUser,)));
}
void toUpdatePassword(context,currentUser) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePasswordPage(currentUser: currentUser,)));
}
void toReauthenticationPage(context,currentUser,accountModel) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => ReauthenticationPage(currentUser: currentUser,accountModel: accountModel,)));
}

void toPreservationsPage(context,currentUserDoc,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarksPage(currentUserDoc,preservatedPostIds,likedPostIds)));
}

void toPreservationsShowPage(context,currentUserDoc,preservationsProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => BookmarkShowPage(currentUserDoc,preservationsProvider,preservatedPostIds,likedPostIds)));
}

void toUserShowPage(context,currentUserDoc,doc,preservatedPostIds,likedPostIds,followingUids) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage(currentUserDoc,doc,preservatedPostIds,likedPostIds,followingUids)));
}
void toFeedShowPage(context,feedsProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedShowPage(feedsProvider,preservatedPostIds,likedPostIds)));
}

void toRecommenderShowPage(context,currentUserDoc,recommendersProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => RecommenderShowPage(currentUserDoc,recommendersProvider,preservatedPostIds,likedPostIds)));
}

void toUserShowPostShowPage(context,currentUserDoc,userShowProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPostShowPage(currentUserDoc,userShowProvider,preservatedPostIds,likedPostIds)));
}

void toAdminPage(context,currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage(currentUserDoc)));
}

void toAccountPage(context,currentUserDoc,currentUser) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage(currentUserDoc: currentUserDoc)));
}

void toNotificationsPage(context,mainProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(mainProvider,preservatedPostIds,likedPostIds)));
}

void toAddPostPage (context,addPostModel,currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage(currentUserDoc: currentUserDoc, addPostModel: addPostModel) ));
}

void toPickPostImagePage(context,addPostModel, currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PickPostImagePage(addPostModel: addPostModel, currentUserDoc: currentUserDoc) ));
}



