// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/toggle_icon.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';

class WhisperDrawer extends StatelessWidget {
  
  final currentUser = FirebaseAuth.instance.currentUser;
  
  WhisperDrawer({
    Key? key,
    required this.mainModel,
    required this.themeModel
  }) : super(key: key);

  final MainModel mainModel;
  final ThemeModel themeModel;
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
            title: Text('アカウント'),
            onTap: () {
              routes.toAccountPage(context, mainModel);
            },
          ),
         
          ListTile(
            title: Text('テーマ変更'),
            trailing: CupertinoSwitch(
              value: themeModel.isDarkTheme, 
              onChanged: (value) { themeModel.setIsDartTheme(value); },
            ),
          ),
          
          ListTile(
            title: Text('NFTowners'),
            onTap: () {
              
            },
          ),
          ListTile(
            title: Text('Whisperについて'),
            onTap: () {
              routes.toImportantMattersPage(context);
            },
          ),
          
        ],
      ),
    );
  }
}