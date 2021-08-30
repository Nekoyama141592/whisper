import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class PostShowPage extends StatelessWidget{
  final DocumentSnapshot doc;
  PostShowPage(this.doc);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('postShow'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            // image
            child: Text(doc.id),
          ),
          Center(
            child: Text(doc['title']),
          )
        ],
      ),
    );
  }
}