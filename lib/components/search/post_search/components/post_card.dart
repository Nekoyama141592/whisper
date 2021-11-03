// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/post_search_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class PostCard extends ConsumerWidget {

  const PostCard({
    Key? key,
    required this.result,
    required this.i,
    required this.mainModel,
    required this.postSearchModel
  }) : super(key: key);
  
  final Map<String,dynamic> result;
  final int i;
  final MainModel mainModel;
  final PostSearchModel postSearchModel;

  @override 
 Widget build(BuildContext context,ScopedReader watch) {

    final postFutures = watch(postsFeaturesProvider);

    final List<Widget>? deleteIcon = [
      IconSlideAction(
        caption: 'Delete',
        color: Colors.transparent,
        icon: Icons.delete,
        onTap: () {
          postSearchModel.onDeleteButtonPressed(context, result, mainModel.currentUserDoc, i);
        },
      ),
    ];
    
    return InkWell(
      onTap: () async {
        await postSearchModel.initAudioPlayer(i);
      },
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        actions: mainModel.currentUserDoc['uid'] != result['uid'] ?
        [
          IconSlideAction(
            caption: 'mute User',
            color: Colors.transparent,
            icon: Icons.person_off,
            onTap: () async {
              await postFutures.muteUserFromPost(mainModel.currentUserDoc, mainModel.mutesUids, result['uid'], i, postSearchModel.results,postSearchModel.afterUris, postSearchModel.audioPlayer);
            } ,
          ),
          IconSlideAction(
            caption: 'mute Post',
            color: Colors.transparent,
            icon: Icons.visibility_off,
            onTap: () async {
              await postFutures.mutePost(mainModel.mutesPostIds,result['postId'],mainModel.prefs,i, postSearchModel.results,postSearchModel.afterUris, postSearchModel.audioPlayer);
            },
          ),
          IconSlideAction(
            caption: 'block User',
            color: Colors.transparent,
            icon: Icons.block,
            onTap: () async {
              await postFutures.blockUserFromPost(mainModel.currentUserDoc,mainModel.blockingUids,result['uid'],i,postSearchModel.results,postSearchModel.afterUris,postSearchModel.audioPlayer);
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
                  leading: RedirectUserImage(userImageURL: result['userImageURL'], length: 50.0, padding: 0.0,passiveUserDocId: result['userDocId'],mainModel: mainModel,),
                  title: Text(
                    result['userName'],
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    result['title'],
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