import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/parts/components/rounded_button.dart';
import 'admin_model.dart';
import 'package:whisper/parts/components/no_right.dart';

class AdminPage extends ConsumerWidget {

  AdminPage(this.currentUserDoc);
  final DocumentSnapshot currentUserDoc;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _adminProvider = watch(adminProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
      ),
      body: currentUserDoc['isAdmin'] ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Tooltip(
            message: '特になし',
            child: Center(
              child: RoundedButton(
                'Nothing', 
                0.8,
                (){
                 
                }, 
                Colors.white, 
                kSecondaryColor
              ),
            ),
          )
        ],
      )
      : NoRight(),
    );
  }
}