// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/colors.dart';

class UserResult extends StatelessWidget {

  UserResult(this.result);
  final Map<String,dynamic> result;

  @override 
  Widget build(BuildContext context) {
    
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.1),
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
              // imageURL
              leading: CircleAvatar(
                radius: 24,
              ),
              title: Text(result['uid']),
              subtitle: Text('sample'),
            )
          ],
        ),
      ),
    );
  }
}