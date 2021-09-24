import 'package:flutter/material.dart';

import 'package:whisper/main.dart';
import 'package:whisper/auth/login/login_page.dart';
import 'package:whisper/auth/signup/signup_page.dart';
import 'package:whisper/parts/bookmarks/bookmarks_page.dart';

import 'package:whisper/parts/posts/feeds/components/feed_show_page.dart';
import 'package:whisper/parts/posts/recommenders/components/recommender_show_page.dart';
import 'package:whisper/parts/user_show/components/user_show_post_show_page.dart';
import 'package:whisper/parts/user_show/user_show_page.dart';
import 'package:whisper/parts/bookmarks/components/bookmark_show_page.dart';
import 'package:whisper/auth/verify/verify_page.dart';
import 'package:whisper/admin/admin_page.dart';
import 'package:whisper/parts/notifications/notifications_page.dart';
import 'package:whisper/parts/add_post/add_post_page.dart';


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

void toNotificationsPage(context,mainProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(mainProvider,preservatedPostIds,likedPostIds)));
}

void toAddPostPage(context,currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage(currentUserDoc)));
}



