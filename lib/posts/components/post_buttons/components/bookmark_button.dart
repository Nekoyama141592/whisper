// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/strings.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class BookmarkButton extends ConsumerWidget {
  
  const BookmarkButton({
    Key? key,
    required this.currentSongMap,
    required this.mainModel
  }) : super(key: key);

  final Map<String,dynamic> currentSongMap;
  final MainModel mainModel;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    
    final postFuturesModel = watch(postsFeaturesProvider);
    final currentWhisperUser = mainModel.currentWhisperUser;
    final List<dynamic> postBookmarks = currentSongMap[bookmarksKey];
    final bookmarksCount = postBookmarks.length;
    final plusOneCount = bookmarksCount + 1;
    return mainModel.bookmarksPostIds.contains(currentSongMap[postIdKey]) ?
    Row(
      children: [
        InkWell(
          child: Icon(
            Icons.bookmark,
            color: Theme.of(context).highlightColor,
          ),
          onTap: () async {
            await postFuturesModel.unbookmark(currentSongMap: currentSongMap, mainModel: mainModel);
          }),
        SizedBox(width: 5.0),
        if(currentWhisperUser.uid == currentSongMap[uidKey]) Text(
          plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万' :  plusOneCount.toString(),
          style: TextStyle(color: Theme.of(context).highlightColor)
        )
      ],
    )
    : Row(
      children: [
        InkWell(
          child: Icon(Icons.bookmark_border),
          onTap: () async {
            await postFuturesModel.bookmark(currentSongMap: currentSongMap, mainModel: mainModel);
          }, 
        ),
        SizedBox(width: 5.0),
        if(currentWhisperUser.uid == currentSongMap[uidKey]) Text(
          bookmarksCount >= 10000 ? (bookmarksCount/1000.floor()/10).toString() + '万' :  bookmarksCount.toString(),
        )
      ],
    );
  }
}