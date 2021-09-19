import 'package:flutter/material.dart';

class LikeNotificationCard extends StatelessWidget {

  LikeNotificationCard(this.notification);
  final Map<String,dynamic> notification;

  @override 
  Widget build(BuildContext context) {
    
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            // imageURL
            leading: CircleAvatar(
              radius: 24,
            ),
            title: Text(notification['uid']),
            subtitle: Text(notification['isRead'].toString()),
          )
        ],
      ),
    );
  }
}