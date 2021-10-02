// // material
// import 'package:flutter/material.dart';
// // package
// import 'package:cloud_firestore/cloud_firestore.dart';
// // components
// import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
// import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
// import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
// import 'package:whisper/posts/components/audio_window/components/current_song_post_id.dart';
// import 'package:whisper/posts/components/details/square_post_image.dart';
// import 'package:whisper/posts/components/comments/comments.dart';
// // model
// import 'package:whisper/components/bookmarks/bookmarks_model.dart';



// class BookmarkShowPage extends StatelessWidget{
//   const BookmarkShowPage({
//     Key? key,
//     required this.currentUserDoc,
//     required this.bookmarksModel,
//     required this.preservatedPostIds,
//     required this.likedPostIds
//   }) : super(key: key);
  
//   final DocumentSnapshot currentUserDoc;
//   final BookMarksModel bookmarksModel;
//   final List preservatedPostIds;
//   final List likedPostIds;

//   @override
//   Widget build(BuildContext context) {
//     final currentSongDocNotifier = bookmarksModel.currentSongDocNotifier;
//     return Scaffold(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         extendBodyBehindAppBar: false,
//         body: SafeArea(
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: IconButton(
//                   padding: EdgeInsets.symmetric(
//                     vertical: 20,
//                   ),
//                   color: Colors.blue,
//                   icon: Icon(Icons.keyboard_arrow_down),
//                   onPressed: (){
//                     Navigator.pop(context);
//                   }, 
//                 ),
//               ),
//               SingleChildScrollView(
//                 child: Container(
//                   child: Column(
//                     children: [
//                       SquarePostImage(currentSongDocNotifier: currentSongDocNotifier),
//                       Center(
//                         child: CurrentSongPostId(currentSongDocNotifier: currentSongDocNotifier)
//                       ),
//                       Center(
//                         child: CurrentSongTitle(currentSongDocNotifier: currentSongDocNotifier)
//                       ),
//                       PostButtons(currentUserDoc, currentSongDocNotifier, preservatedPostIds, likedPostIds),
//                       AudioStateDesign(
//                         preservatedPostIds: preservatedPostIds,
//                         likedPostIds: likedPostIds,
//                         currentSongDocNotifier: bookmarksModel.currentSongDocNotifier,
//                         progressNotifier: bookmarksModel.progressNotifier,
//                         seek: bookmarksModel.seek,
//                         repeatButtonNotifier: bookmarksModel.repeatButtonNotifier,
//                         onRepeatButtonPressed: (){
//                           bookmarksModel.onRepeatButtonPressed();
//                         },
//                         isFirstSongNotifier: bookmarksModel.isFirstSongNotifier,
//                         onPreviousSongButtonPressed: (){
//                           bookmarksModel.onPreviousSongButtonPressed();
//                         },
//                         playButtonNotifier: bookmarksModel.playButtonNotifier,
//                         play: (){
//                           bookmarksModel.play();
//                         },
//                         pause: (){
//                           bookmarksModel.pause();
//                         },
//                         isLastSongNotifier: bookmarksModel.isLastSongNotifier,
//                         onNextSongButtonPressed: (){
//                           bookmarksModel.onNextSongButtonPressed();
//                         }
//                       ),
                      
//                     ],
//                   ),
//                 ),
//               ),
//               Comments(currentSongDocNotifier: currentSongDocNotifier)
//             ],
//           ),
//         ),
//       );
      
//   }
// }