// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/posts/components/comments/components/comment_like_button.dart';
import 'package:whisper/posts/components/comments/components/show_replys_button.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class CommentCard extends ConsumerWidget {

  const CommentCard({
    Key? key,
    required this.comment,
    required this.currentSongMap,
    required this.commentsModel,
    required this.replysModel,
    required this.mainModel
  }): super(key: key);
  
  final Map<String,dynamic> comment;
  final Map<String,dynamic> currentSongMap;
  final CommentsModel commentsModel;
  final ReplysModel replysModel;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context,ScopedReader watch) {
    
    final postFutures = watch(postsFeaturesProvider);
    final fontSize = 16.0;
    final whisperTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      // overflow: TextOverflow.ellipsis
    );
    return isDisplayUidFromMap(mutesUids: mainModel.mutesUids, blocksUids: mainModel.blocksUids, mutesIpv6s: mainModel.mutesIpv6s, blocksIpv6s: mainModel.blocksIpv6s , map: comment ) && !mainModel.mutesCommentIds.contains(comment[commentIdKey]) ?

    Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: !(comment[uidKey] == mainModel.currentUserDoc[uidKey]) ?
      [
        IconSlideAction(
          caption: 'mute User',
          color: Colors.transparent,
          icon: Icons.person_off,
          onTap: () async {
            await postFutures.muteUser(mutesUids: mainModel.mutesUids, currentUserDoc: mainModel.currentUserDoc, mutesIpv6AndUids: mainModel.mutesIpv6AndUids, map: comment);
          } ,
        ),

        IconSlideAction(
          caption: 'block User',
          color: Colors.transparent,
          icon: Icons.block,
          onTap: () async {
            await postFutures.blockUser(blocksUids: mainModel.blocksUids,currentUserDoc: mainModel.currentUserDoc,blocksIpv6AndUids: mainModel.blocksIpv6AndUids,map: comment);
          },
        ),
      ]: [],
      child: InkWell(
        onLongPress: mainModel.currentUserDoc[isAdminKey] ? () async {
          await FlutterClipboard.copy(comment[uidKey]);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uidをコピーしました')));
        } : null,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0
                      ),
                      child: RedirectUserImage(userImageURL: comment[userImageURLKey], length: 60.0, padding: 0.0, passiveUserDocId: comment[uidKey], mainModel: mainModel),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            comment[userNameKey],
                            style: whisperTextStyle,
                          ),
                          SizedBox(height: 10.0,),
                          Text(
                            comment[commentKey],
                            style: whisperTextStyle,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CommentLikeButton(commentsModel: commentsModel, currentUserDoc: mainModel.currentUserDoc, likedCommentIds: mainModel.likeCommentIds, comment: comment, likedComments: mainModel.likeComments),
                        ShowReplyButton(mainModel: mainModel, replysModel: replysModel, currentUserDoc: mainModel.currentUserDoc, thisComment: comment, currentSongMap: currentSongMap)
                      ],
                    )
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    ) : SizedBox.shrink();
  }
}