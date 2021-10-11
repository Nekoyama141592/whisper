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
import 'package:whisper/components/home/recommenders/recommenders_model.dart';

class PostCard extends StatelessWidget {
  
  const PostCard({
    Key? key,
    required this.i,
    required this.postDoc,
    required this.mainModel,
    required this.recommendersModel
  }) : super(key: key);

  final int i;
  final DocumentSnapshot postDoc;
  final MainModel mainModel;
  final RecommendersModel recommendersModel;

  @override  
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await recommendersModel.initAudioPlayer(i);
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: [
          IconSlideAction(
            caption: 'Archive',
            color: Colors.transparent,
            icon: Icons.archive,
            
            onTap: () => print("archive"),
          ),
          IconSlideAction(
            caption: 'Share',
            color: Colors.transparent,
            icon: Icons.share,
            onTap: () => print('Share'),
          ),
          IconSlideAction(
            caption: 'More',
            color: Colors.transparent,
            icon: Icons.more_horiz,
            onTap: () => print('More'),
          ),
          IconSlideAction(
            caption: 'Delete',
            color: Colors.transparent,
            icon: Icons.delete,
            onTap: () => print('Delete'),
          )
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