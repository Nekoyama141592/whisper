// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
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
    final whisperPost = fromMapToPost(postMap: post);
    return Padding(
      padding: EdgeInsets.all( defaultPadding(context: context)/4.0 ),
      child: InkWell(
        onTap: initAudioPlayer,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          actions: mainModel.currentWhisperUser.uid!= whisperPost.uid ? 
          [
            IconSlideAction(
              caption: 'Mute User',
              color: Colors.transparent,
              icon: Icons.person_off,
              onTap: muteUser
            ),
            IconSlideAction(
              caption: 'Mute Post',
              color: Colors.transparent,
              icon: Icons.visibility_off,
              onTap: mutePost
            ),
            IconSlideAction(
              caption: 'Block User',
              color: Colors.transparent,
              icon: Icons.block,
              onTap: blockUser
            ),
          ] : deleteIcon,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).focusColor.withOpacity(cardOpacity),
              ),
              borderRadius: BorderRadius.circular( defaultPadding(context: context) )
            ),
            child: ListTile(
              leading: RedirectUserImage(userImageURL: whisperPost.userImageURL, length: defaultPadding(context: context) * 4.0, padding: 0.0, passiveUserDocId: whisperPost.uid, mainModel: mainModel),
              title: Text(
                whisperPost.userName,
                style: TextStyle(
                  fontSize: defaultHeaderTextSize(context: context)/cardTextDiv
                ),
              ),
              subtitle: Text(
                whisperPost.title,
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: defaultHeaderTextSize(context: context)
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}