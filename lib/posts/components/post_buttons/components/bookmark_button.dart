// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// model
import 'package:whisper/posts/components/post_buttons/posts_futures.dart';

class BookmarkButton extends ConsumerWidget {
  
  const BookmarkButton({
    Key? key,
    required this.currentUserDoc,
    required this.currentSongMap,
    required this.bookmarkedPostIds,
    required this.bookmarks
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> currentSongMap;
  final List bookmarkedPostIds;
  final List bookmarks;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    
    final postFuturesModel = watch(postsFeaturesProvider);

   
        final List postBookmarks = currentSongMap['bookmarks'];
        final bookmarksCount = postBookmarks.length;
        final plusOneCount = bookmarksCount + 1;
        return 
        bookmarkedPostIds.contains(currentSongMap['postId']) ?
        Row(
          children: [
            InkWell(
              child: Icon(
                Icons.bookmark,
                color: Theme.of(context).highlightColor,
              ),
              onTap: () async {
                await postFuturesModel.unbookmark(bookmarkedPostIds, currentUserDoc, currentSongMap, bookmarks);
              }, 
            ),
            SizedBox(width: 5.0),
            if(currentUserDoc['uid'] == currentSongMap['uid']) Text(
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
                await postFuturesModel.bookmark(bookmarkedPostIds, currentUserDoc, currentSongMap, bookmarks);
              }, 
            ),
            SizedBox(width: 5.0),
            if(currentUserDoc['uid'] == currentSongMap['uid']) Text(
              bookmarksCount >= 10000 ? (bookmarksCount/1000.floor()/10).toString() + '万' :  bookmarksCount.toString(),
            )
          ],
        );
    
    
  }
}