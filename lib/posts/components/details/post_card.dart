// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_slidable/flutter_slidable.dart';
// constants
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';

class PostCard extends StatelessWidget {

  const PostCard({
    Key? key,
    required this.post,
    required this.onDeleteButtonPressed,
    required this.initAudioPlayer,
    required this.muteUser,
    required this.mutePost,
    required this.blockUser,
    required this.mainModel
  }) : super(key: key);

  final Map<String,dynamic> post;
  final void Function()? onDeleteButtonPressed;
  final void Function()? initAudioPlayer;
  final void Function()? muteUser;
  final void Function()? mutePost;
  final void Function()? blockUser;
  final MainModel mainModel;

  @override 
  
  Widget build(BuildContext context) {

    final List<Widget>? deleteIcon = [
      IconSlideAction(
        caption: 'Delete',
        color: Colors.transparent,
        icon: Icons.delete,
        onTap: onDeleteButtonPressed
      ),
    ];
    return InkWell(
      onTap: initAudioPlayer,
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: mainModel.currentWhisperUser.uid!= post[uidKey] ? 
        [
          IconSlideAction(
            caption: 'mute User',
            color: Colors.transparent,
            icon: Icons.person_off,
            onTap: muteUser
          ),
          IconSlideAction(
            caption: 'mute Post',
            color: Colors.transparent,
            icon: Icons.visibility_off,
            onTap: mutePost
          ),
          IconSlideAction(
            caption: 'block User',
            color: Colors.transparent,
            icon: Icons.block,
            onTap: blockUser
          ),
        ] : deleteIcon,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).highlightColor.withOpacity(0.1),
                blurRadius: 15.0,
              )
            ]
          ),
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: RedirectUserImage(userImageURL: post[userImageURLKey], length: 50.0, padding: 0.0, passiveUserDocId: post[uidKey], mainModel: mainModel),
                  title: Text(
                    post[userNameKey],
                    style: TextStyle(
                      fontSize: 20.0
                    ),
                  ),
                  subtitle: Text(
                    post[titleKey],
                    style: TextStyle(
                      color: Theme.of(context).focusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
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