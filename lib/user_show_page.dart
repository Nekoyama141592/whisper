import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserShowPage extends StatelessWidget {
  final DocumentSnapshot doc;
  UserShowPage(this.doc);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('userShow'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            // image
            child: Text(doc.id),
          ),
        ],
      ),
    );
  }
}