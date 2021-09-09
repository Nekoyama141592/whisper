import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostCard extends StatelessWidget {
  
  final DocumentSnapshot doc;
  PostCard(this.doc);

  @override  
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 24,
            ),
            title: doc['title'],
            subtitle: doc['userName'],
            trailing: doc['createdAt'],
          )
        ],
      ),
    );
  }
}