import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/main_model.dart';

class WhisperDrawer extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  final List preservatedPostIds;
  
  WhisperDrawer(this.mainProvider,this.preservatedPostIds);

  final MainModel mainProvider;
  @override  
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Preservations'),
            onTap: () {
              routes.toPreservationsPage(context,preservatedPostIds);
            },
          ),
          ListTile(
            title: Text('Add Post'),
            onTap: () {
              routes.toAddPostsPage(context);
            },
          ),
          ListTile(
            title: Text('User Show'),
            onTap: () {
              routes.toUserShowPage(context, mainProvider.currentUserdoc,preservatedPostIds);
            },
          ),
        ],
      ),
    );
  }
}