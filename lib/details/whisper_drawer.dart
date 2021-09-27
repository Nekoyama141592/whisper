import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/main_model.dart';

class WhisperDrawer extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  
  WhisperDrawer(this.mainProvider);

  final MainModel mainProvider;
  
  @override  
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          
          mainProvider.currentUserDoc['isAdmin'] ?
          ListTile(
            title: Text('Admin'),
            onTap: () {
              routes.toAdminPage(context,mainProvider.currentUserDoc);
            },
          )
          : SizedBox.shrink(),
          ListTile(
            title: Text('Account'),
            onTap: () {
              routes.toAccountPage(context,mainProvider.currentUserDoc,mainProvider.currentUser);
            },
          )
        ],
      ),
    );
  }
}