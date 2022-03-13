// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_card.dart';
// models
import 'package:whisper/main_model.dart';

class UserCards extends StatelessWidget {

  const UserCards({
    Key? key,
    required this.userDocs,
    required this.mainModel,
  }) : super(key: key);

  final List<DocumentSnapshot<Map<String,dynamic>>> userDocs;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: userDocs.length,
        itemBuilder: (context,i) {
          return UserCard(result: userDocs[i].data()!, mainModel: mainModel);
        }
      ),
    );
  }
}