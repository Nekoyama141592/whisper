// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
class PostCard extends StatelessWidget {
  
  const PostCard({
    Key? key,
    required this.i,
    required this.postDoc,
    required this.mainModel,
    required this.userShowModel,
  }) : super(key: key);

  final int i;
  final DocumentSnapshot postDoc;
  final MainModel mainModel;
  final UserShowModel userShowModel;

  @override  
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await userShowModel.initAudioPlayer(i);
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: [
          IconSlideAction(
            caption: 'mute User',
            color: Colors.transparent,
            icon: Icons.person_off,
            onTap: () => print("mute User"),
          ),
          IconSlideAction(
            caption: 'mute Post',
            color: Colors.transparent,
            icon: Icons.visibility_off,
            onTap: () => print("mute comment"),
          ),
          IconSlideAction(
            caption: 'block User',
            color: Colors.transparent,
            icon: Icons.block,
            onTap: () => print("blockUser"),
          ),
        ],
        child: Container(
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
                  leading: RedirectUserImage(userImageURL: postDoc['userImageURL'], length: 50.0, padding: 0.0, passiveUserDocId: postDoc['userDocId'], mainModel: mainModel),
                  title: Text(postDoc['userName']),
                  subtitle: Text(
                    postDoc['title'],
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}