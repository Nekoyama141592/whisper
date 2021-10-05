// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/user_image.dart';
class CommentCard extends StatelessWidget {

  const CommentCard({
    Key? key,
    required this.comment
  }): super(key: key);
  
  final Map<String,dynamic> comment;

  @override  
  Widget build(BuildContext context){
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            // imageURL
            leading: UserImage(
              userImageURL: comment['userImageURL'], 
              length: 60.0, 
              padding: 0.0
            ),
            title: Text(comment['userName']),
            subtitle: Text(comment['comment']),
          )
        ],
      ),
    );
  }
}