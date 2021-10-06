// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';

class ReplyCard extends StatelessWidget {

  const ReplyCard({
    Key? key,
    required this.reply
  }) : super(key: key);

  final DocumentSnapshot reply;
  Widget build(BuildContext context) {
    final String userImageURL = reply['userImageURL'];
    final length = 60.0;
    final padding = 0.0;

    return ListTile(
      leading: UserImage(userImageURL: userImageURL, length: length, padding: padding),
      title: Text(reply['userName']),
      subtitle: Text('reply'),
    );
  }

}