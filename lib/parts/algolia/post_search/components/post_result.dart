import 'package:flutter/material.dart';

class PostResult extends StatelessWidget {

  PostResult(this.result);
  final Map<String,dynamic> result;

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
            title: Text(result['title']),
            subtitle: Text('sample'),
          )
        ],
      ),
    );
  }
}