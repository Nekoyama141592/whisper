// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/no_right.dart';
import 'package:whisper/details/rounded_button.dart';
// model
import 'admin_model.dart';

class AdminPage extends ConsumerWidget {

  const AdminPage({
    Key? key,
    required this.currentUserDoc
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final adminModel = watch(adminProvider);
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
                20,
                10,
                (){
                }, 
                Colors.white, 
                Theme.of(context).colorScheme.secondary
              ),
            ),
          )
        ],
      )
      : NoRight(),
    );
  }
}