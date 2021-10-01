import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/details/user_image.dart';

import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/play_button.dart';
import 'package:whisper/posts/components/audio_window/components/audio_progress_bar.dart';
class AudioWindow extends StatelessWidget {
  
  const AudioWindow({
    Key? key,
    required this.addPostModel,
    required this.currentUserDoc,
  }) : super(key: key);
  
  final AddPostModel addPostModel;
  final DocumentSnapshot currentUserDoc;

  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    final audioWindowHeight = size.height * 0.15;
    final progressNotifier = addPostModel.progressNotifier;
    final seek = addPostModel.seek;

    return Container(
      height: audioWindowHeight,
      child: Column(
        children: [
          AudioProgressBar(progressNotifier: progressNotifier, seek: seek),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                ),
                child: UserImage(userImageURL: currentUserDoc['imageURL'],length: 60.0,padding: 5.0,)
              ),
              Container(
                width: size.width * 0.55,
                child: Column(
                  children: [
                    Text(
                      currentUserDoc['userName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    ValueListenableBuilder<String>(
                      valueListenable: addPostModel.postTitleNotifier,
                      builder: (_,postTitle,__) {
                        return 
                        Text(
                          postTitle,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        );
                      }
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PlayButton(
                      addPostModel.playButtonNotifier,
                      (){
                        addPostModel.play();
                      },
                      (){
                        addPostModel.pause();
                      }
                    ),
                  ],
                ),
              )
            ],
          )
        ]
      ),
    );
  }
}
