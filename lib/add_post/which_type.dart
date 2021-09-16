import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/parts/rounded_button.dart';

class WhichType extends StatelessWidget {

  final DocumentSnapshot currentUserDoc;
  WhichType(this.currentUserDoc);
  @override 
  Widget build(BuildContext context) {
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Which type?'),
        RoundedButton(
          '普通の投稿', 
          () {
            routes.toAddPostPage(context, currentUserDoc);
          }, 
          Colors.white, 
          kTertiaryColor
        ),
        RoundedButton(
          '広告の投稿',
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                
                content: Text('実装予定です！')
              )
            );
          }, 
          Colors.black, 
          kQuaternaryColor
        )
      ],
    );
  }
}