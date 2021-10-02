// // material
// import 'package:flutter/material.dart';
// // components
// import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
// import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
// import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
// import 'package:whisper/posts/components/audio_window/components/current_song_post_id.dart';
// import 'package:whisper/posts/components/details/square_post_image.dart';
// import 'package:whisper/posts/components/comments/comments.dart';
// // model
// import 'package:whisper/components/home/feeds/feeds_model.dart';

// class FeedShowPage extends StatelessWidget{
  
//   const FeedShowPage({
//     required this.feedsModel,
//     required this.preservatedPostIds,
//     required this.likedPostIds
//   });

//   final FeedsModel feedsModel;
//   final List preservatedPostIds;
//   final List likedPostIds;

//   @override
//   Widget build(BuildContext context) {
//     final currentSongDocNotifier = feedsModel.currentSongDocNotifier;
//     final currentUserDoc = feedsModel.currentUserDoc;

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
//                         currentSongDocNotifier: feedsModel.currentSongDocNotifier,
//                         progressNotifier: feedsModel.progressNotifier,
//                         seek: feedsModel.seek,
//                         repeatButtonNotifier: feedsModel.repeatButtonNotifier,
//                         onRepeatButtonPressed: (){
//                           feedsModel.onRepeatButtonPressed();
//                         },
//                         isFirstSongNotifier: feedsModel.isFirstSongNotifier,
//                         onPreviousSongButtonPressed: (){
//                           feedsModel.onPreviousSongButtonPressed();
//                         },
//                         playButtonNotifier: feedsModel.playButtonNotifier,
//                         play: (){
//                           feedsModel.play();
//                         },
//                         pause: (){
//                           feedsModel.pause();
//                         },
//                         isLastSongNotifier: feedsModel.isLastSongNotifier,
//                         onNextSongButtonPressed: (){
//                           feedsModel.onNextSongButtonPressed();
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