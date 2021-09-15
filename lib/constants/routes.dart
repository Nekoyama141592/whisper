import 'package:flutter/material.dart';

import 'package:whisper/main.dart';
import 'package:whisper/auth/login/login_page.dart';
import 'package:whisper/auth/signup/signup_page.dart';
import 'package:whisper/preservations/preservations_page.dart';
import 'package:whisper/users/user_show/user_show_page.dart';
import 'package:whisper/parts/posts/feeds/components/feed_show_page.dart';
import 'package:whisper/parts/posts/recommenders/components/recommender_show_page.dart';
import 'package:whisper/users/user_show/user_show_post_show_page.dart';
import 'package:whisper/preservations/components/preservation_show_page.dart';
import 'package:whisper/auth/verify/verify_page.dart';
import 'package:whisper/admin/admin_page.dart';
import 'package:whisper/parts/notifications/notifications_page.dart';

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
  Navigator.push(context, MaterialPageRoute(builder: (context) => PreservationsPage(currentUserDoc,preservatedPostIds,likedPostIds)));
}

void toPreservationsShowPage(context,currentUserDoc,doc,preservationsProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PreservationShowPage(currentUserDoc,doc,preservationsProvider,preservatedPostIds,likedPostIds)));
}

void toUserShowPage(context,currentUserDoc,userDoc,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage(currentUserDoc,userDoc,preservatedPostIds,likedPostIds)));
}
void toFeedShowPage(context,userDoc,feedsProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedShowPage(userDoc,feedsProvider,preservatedPostIds,likedPostIds)));
}

void toRecommenderShowPage(context,currentUserDoc,userDoc,recommendersProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => RecommenderShowPage(currentUserDoc,userDoc,recommendersProvider,preservatedPostIds,likedPostIds)));
}

void toUserShowPostShowPage(context,currentUserDoc,userDoc,userShowProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPostShowPage(currentUserDoc,userDoc,userShowProvider,preservatedPostIds,likedPostIds)));
}

void toAdminPage(context,currentUserDoc) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AdminPage(currentUserDoc)));
}

void toNotificationsPage(context,mainProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage(mainProvider,preservatedPostIds,likedPostIds)));
}




