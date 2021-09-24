import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {

  CommentCard(this.comment);
  final Map<String,dynamic> comment;

  @override  
  Widget build(BuildContext context){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            // imageURL
            leading: CircleAvatar(
              radius: 24,
            ),
            title: Text(comment['commentId']),
            subtitle: Text('sample'),
          )
        ],
      ),
    );
  }
}