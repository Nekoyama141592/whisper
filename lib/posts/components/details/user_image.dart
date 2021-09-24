import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    Key? key,
    required this.doc,
  }) : super(key: key);

  final DocumentSnapshot doc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: NetworkImage(doc['imageURL'])
        ),
      ),
    );
  }
}