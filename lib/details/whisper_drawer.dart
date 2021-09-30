// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';

class WhisperDrawer extends StatelessWidget {
  
  final currentUser = FirebaseAuth.instance.currentUser;
  
  WhisperDrawer({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;
  
  @override  
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          
          mainModel.currentUserDoc['isAdmin'] ?
          ListTile(
            title: Text('Admin'),
            onTap: () {
              routes.toAdminPage(context,mainModel.currentUserDoc);
            },
          )
          : SizedBox.shrink(),
          ListTile(
            title: Text('Account'),
            onTap: () {
              routes.toAccountPage(context,mainModel.currentUserDoc,mainModel.currentUser);
            },
          ),
          ListTile(
            title: Text('テーマ変更'),
            trailing: Icon(Icons.toggle_off),
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }
}