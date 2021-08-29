import 'package:flutter/material.dart';

import 'package:whisper/main.dart';
import 'package:whisper/auth/login/login_page.dart';
import 'package:whisper/auth/signup/signup_page.dart';
import 'package:whisper/preservations/preservations_page.dart';
import 'package:whisper/add_post/add_post_page.dart';
void toMyApp(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
}

void toLoginpage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
}

void toSignupPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
}

void toPreservationsPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => PreservationsPage()));
}

void toAddPostsPage(context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPostPage()));
}


