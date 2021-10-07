// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/user_image.dart';

class ReaplyNotificationCard extends StatelessWidget {

  const ReaplyNotificationCard({
    Key? key,
    required this.replyNotification
  }) : super(key: key);
  
  final Map<String,dynamic> replyNotification;

  @override 
  Widget build(BuildContext context) {
    final userImageURL = replyNotification['userImageURL'];
    final length = 60.0;
    final padding = 0.0;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: UserImage(userImageURL: userImageURL, length: length, padding: padding),
            title: Text(replyNotification['userName']),
            subtitle: Text(replyNotification['comment']),
          )
        ],
      ),
    );
  }
}