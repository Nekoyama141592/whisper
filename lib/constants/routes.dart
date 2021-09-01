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

void toMyApp(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
}

void toLoginpage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

void toSignupPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
}

void toPreservationsPage(context,preservatedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PreservationsPage(preservatedPostIds)));
}

void toAddPostsPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage()));
}

void toUserShowPage(context,userDoc,preservatedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPage(userDoc,preservatedPostIds)));
}
void toFeedShowPage(context,userDoc,feedsProvider,preservatedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => FeedShowPage(userDoc,feedsProvider,preservatedPostIds)));
}

void toRecommenderShowPage(context,userDoc,recommendersProvider,preservatedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => RecommenderShowPage(userDoc,recommendersProvider,preservatedPostIds)));
}

void toUserShowPostShowPage(context,userDoc,userShowProvider,preservatedPostIds) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => UserShowPostShowPage(userDoc,userShowProvider,preservatedPostIds)));
}




