import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/main_model.dart';

class WhisperDrawer extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  
  WhisperDrawer(this.mainProvider,this.preservatedPostIds,this.likedPostIds);

  final MainModel mainProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override  
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Preservations'),
            onTap: () {
              routes.toPreservationsPage(context,preservatedPostIds,likedPostIds);
            },
          ),
          mainProvider.currentUserdoc['isAdmin'] ?
          ListTile(
            title: Text('Admin'),
            onTap: () {
              routes.toAdminPage(context);
            },
          )
          : SizedBox()
        ],
      ),
    );
  }
}