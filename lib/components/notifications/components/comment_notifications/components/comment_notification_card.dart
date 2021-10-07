// material
import 'package:flutter/material.dart';
import 'package:whisper/details/user_image.dart';

class CommentNotificationCard extends StatelessWidget {

  const CommentNotificationCard({
    Key? key,
    required this.notification
  }) : super(key: key);
  
  final Map<String,dynamic> notification;

  @override 
  Widget build(BuildContext context) {
    final userImageURL = notification['userImageURL'];
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
           leading: UserImage(userImageURL: userImageURL, length: 60.0, padding: 0.0),
            title: Text(notification['userName']),
            subtitle: Text(notification['comment']),
          )
        ],
      ),
    );
  }
}