// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/user_image.dart';

class PostResult extends StatelessWidget {

  const PostResult({
    Key? key,
    required this.result
  }) : super(key: key);
  
  final Map<String,dynamic> result;

  @override 
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).highlightColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 5)
          )
        ]
      ),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: UserImage(userImageURL: result['userImageURL'], length: 50.0, padding: 0.0),
              title: Text(result['userName']),
              subtitle: Text(
                result['title'],
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}