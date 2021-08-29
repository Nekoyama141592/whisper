import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/add_post/add_post_page.dart';
import 'package:whisper/preservations/preservations_page.dart';

class WhisperDrawer extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override  
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Preservations'),
            onTap: () {
              routes.toPreservationsPage(context);
            },
          ),
          ListTile(
            title: Text('Add Post'),
            onTap: () {
              routes.toAddPostsPage(context);
            },
          ),
        ],
      ),
    );
  }
}