// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'user_image.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';

class RedirectUserImage extends StatelessWidget {
  
  const RedirectUserImage({
    Key? key,
    required this.userImageURL,
    required this.length,
    required this.padding,
    required this.passiveUserDocId,
    required this.mainModel
  }) : super(key: key);

  final String userImageURL;
  final double length;
  final double padding;
  final String passiveUserDocId;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final passiveUserDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(passiveUserDocId)
        .get();
        routes.toUserShowPage(context, passiveUserDoc, mainModel);
      },
      child: UserImage(padding: padding, length: length, userImageURL: userImageURL)
    );
  }
}