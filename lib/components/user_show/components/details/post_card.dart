// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class PostCard extends ConsumerWidget {
  
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
  Widget build(BuildContext context,ScopedReader watch) {

    final postFutures = watch(postsFeaturesProvider);
    final List<Widget>? deleteIcon = [
      IconSlideAction(
        caption: 'Delete',
        color: Colors.transparent,
        icon: Icons.delete,
        onTap: () {
          userShowModel.onDeleteButtonPressed(context, postDoc, mainModel.currentUserDoc, i);
        },
      ),
    ];
    return InkWell(
      onTap: () async {
        await userShowModel.initAudioPlayer(i);
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: mainModel.currentUserDoc['uid'] != postDoc['uid'] ? 
        [
          IconSlideAction(
            caption: 'mute User',
            color: Colors.transparent,
            icon: Icons.person_off,
            onTap: () async {
              await userShowModel.muteUser(mainModel.mutesUids, postDoc['uid'], mainModel.prefs, i, mainModel.currentUserDoc);
            } ,
          ),
          IconSlideAction(
            caption: 'mute Post',
            color: Colors.transparent,
            icon: Icons.visibility_off,
            onTap: () async {
              await userShowModel.mutePost(mainModel.mutesPostIds, postDoc['postId'], mainModel.prefs, i);
            },
          ),
          IconSlideAction(
            caption: 'block User',
            color: Colors.transparent,
            icon: Icons.block,
            onTap: () async {
              await userShowModel.blockUser(mainModel.currentUserDoc, mainModel.blockingUids, postDoc['uid'], i);
            },
          ),
        ] : deleteIcon,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).focusColor.withOpacity(0.3),
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
                  title: Text(
                    postDoc['userName'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    postDoc['title'],
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
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