import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/parts/posts/posts_futures.dart';

class PreservateButton extends StatelessWidget {
  PreservateButton(this.uid,this.postDoc);
  final String uid;
  final DocumentSnapshot postDoc;
  @override  
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.inventory_2),
      onPressed: () {
        preservate(uid, postDoc);
      }, 
    );
  }
}