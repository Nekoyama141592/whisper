// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/post_buttons/components/report_post_button.dart';

class PostCard extends StatelessWidget {

  const PostCard({
    Key? key,
    required this.postDoc,
    required this.onDeleteButtonPressed,
    required this.initAudioPlayer,
    required this.muteUser,
    required this.mutePost,
    required this.reportPost,
    required this.reportPostButtonBuilder,
    required this.mainModel
  }) : super(key: key);

  final DocumentSnapshot<Map<String,dynamic>> postDoc;
  final void Function()? onDeleteButtonPressed;
  final void Function()? initAudioPlayer;
  final void Function()? muteUser;
  final void Function()? mutePost;
  final void Function()? reportPost;
  final Widget Function(BuildContext) reportPostButtonBuilder;
  final MainModel mainModel;

  @override 
  
  Widget build(BuildContext context) {

    final whisperPost = fromMapToPost(postMap: postDoc.data()!);
    return Padding(
      padding: EdgeInsets.all( defaultPadding(context: context)/4.0 ),
      child: InkWell(
        onTap: initAudioPlayer,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).focusColor.withOpacity(cardOpacity),
            ),
            borderRadius: BorderRadius.circular( defaultPadding(context: context) )
          ),
          child: ListTile(
            leading: RedirectUserImage(userImageURL: whisperPost.userImageURL, length: defaultPadding(context: context) *3.0, padding: 0.0, passiveUid: whisperPost.uid, mainModel: mainModel),
            trailing: ReportPostButton(builder: reportPostButtonBuilder),
            title: Text(
              mainModel.currentWhisperUser.uid == whisperPost.uid ?
              mainModel.currentWhisperUser.userName
              : whisperPost.userName,
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
    );
  }
}