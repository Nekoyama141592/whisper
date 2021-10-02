// // material
// import 'package:flutter/material.dart';
// // packages
// import 'package:cloud_firestore/cloud_firestore.dart';
// // components
// import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
// import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
// import 'package:whisper/posts/components/audio_window/components/current_song_post_id.dart';
// import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
// import 'package:whisper/posts/components/details/square_post_image.dart';
// import 'package:whisper/posts/components/comments/comments.dart';
// // model
// import 'package:whisper/components/user_show/user_show_model.dart';


// class UserShowPostShowPage extends StatelessWidget {
  
//   const UserShowPostShowPage({
//     Key? key,
//     required this.currentUserDoc,
//     required this.userShowModel,
//     required this.preservatedPostIds,
//     required this.likedPostIds
//   });
  
//   final UserShowModel userShowModel;
//   final DocumentSnapshot currentUserDoc;
//   final List preservatedPostIds;
//   final List likedPostIds;

//   @override
//   Widget build(BuildContext context) {
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
//                       SquarePostImage(currentSongDocNotifier: userShowModel.currentSongDocNotifier),
//                       Center(
//                         child: CurrentSongPostId(currentSongDocNotifier: userShowModel.currentSongDocNotifier),
//                       ),
//                       Center(
//                         child: CurrentSongTitle(currentSongDocNotifier: userShowModel.currentSongDocNotifier),
//                       ),
//                       PostButtons(currentUserDoc, userShowModel.currentSongDocNotifier, preservatedPostIds, likedPostIds),
//                       AudioStateDesign(
//                         preservatedPostIds: preservatedPostIds,
//                         likedPostIds: likedPostIds,
//                         currentSongDocNotifier: userShowModel.currentSongDocNotifier,
//                         progressNotifier: userShowModel.progressNotifier,
//                         seek: userShowModel.seek,
//                         repeatButtonNotifier: userShowModel.repeatButtonNotifier,
//                         onRepeatButtonPressed: (){
//                           userShowModel.onRepeatButtonPressed();
//                         },
//                         isFirstSongNotifier: userShowModel.isFirstSongNotifier,
//                         onPreviousSongButtonPressed: (){
//                           userShowModel.onPreviousSongButtonPressed();
//                         },
//                         playButtonNotifier: userShowModel.playButtonNotifier,
//                         play: (){
//                           userShowModel.play();
//                         },
//                         pause: (){
//                           userShowModel.pause();
//                         },
//                         isLastSongNotifier: userShowModel.isLastSongNotifier,
//                         onNextSongButtonPressed: (){
//                           userShowModel.onNextSongButtonPressed();
//                         }
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Comments(currentSongDocNotifier: userShowModel.currentSongDocNotifier)
//             ],
//           ),
//         ),
//       );
//   }
// }