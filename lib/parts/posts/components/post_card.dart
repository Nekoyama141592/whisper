import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class PostCard extends StatelessWidget {
  
  final DocumentSnapshot doc;
  PostCard(this.doc);

  @override  
  Widget build(BuildContext context) {
    // final date = Timestamp.now().toDate();
    final Timestamp timeStamp = doc['createdAt'];
    final date = timeStamp.toDate();
    final year = date.year.toString();
    final month = date.month.toString();
    final day = date.day.toString();
    final hour = date.hour.toString();
    final minute = date.minute.toString();
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            // imageURL
            leading: CircleAvatar(
              radius: 24,
            ),
            title: Text(doc['title']),
            subtitle: Text(doc.id),
            trailing: Text(year + "/" + month + "/" + day + " " + hour + "時" + minute + "分"),
          )
        ],
      ),
    );
  }
}