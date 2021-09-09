import 'package:flutter/material.dart';

import 'package:whisper/main.dart';
import 'package:whisper/auth/login/login_page.dart';
import 'package:whisper/auth/signup/signup_page.dart';
import 'package:whisper/preservations/preservations_page.dart';
import 'package:whisper/add_post/add_post_page.dart';
import 'package:whisper/users/user_show/user_show_page.dart';
import 'package:whisper/parts/posts/feeds/components/feed_show_page.dart';
import 'package:whisper/parts/posts/recommenders/components/recommender_show_page.dart';
import 'package:whisper/users/user_show/user_show_post_show_page.dart';
import 'package:whisper/preservations/preservation_show_page.dart';
import 'package:whisper/auth/verify/verify_page.dart';
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

void toPreservationsPage(context,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PreservationsPage(preservatedPostIds,likedPostIds)));
}

void toPreservationsShowPage(context,doc,preservationsProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PreservationShowPage(doc,preservationsProvider,preservatedPostIds,likedPostIds)));
}

void toUserShowPage(context,userDoc,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage(userDoc,preservatedPostIds,likedPostIds)));
}
void toFeedShowPage(context,userDoc,feedsProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedShowPage(userDoc,feedsProvider,preservatedPostIds,likedPostIds)));
}

void toRecommenderShowPage(context,userDoc,recommendersProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => RecommenderShowPage(userDoc,recommendersProvider,preservatedPostIds,likedPostIds)));
}

void toUserShowPostShowPage(context,userDoc,userShowProvider,preservatedPostIds,likedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPostShowPage(userDoc,userShowProvider,preservatedPostIds,likedPostIds)));
}




