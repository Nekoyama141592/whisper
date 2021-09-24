import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/posts/components/user_image.dart';

import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/posts/audio_controll/audio_controll_buttons/components/play_button.dart';
import 'package:whisper/posts/components/audio_progress_bar.dart';
class AudioWindow extends StatelessWidget {
  
  AudioWindow(
    this.addPostProvider,
    this.currentUserDoc,
    // this.postTitleController
  );
  final AddPostModel addPostProvider;
  final DocumentSnapshot currentUserDoc;
  // final TextEditingController postTitleController;

  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioWindowHeight = size.height * 0.15;
    return Container(
      height: audioWindowHeight,
      child: Column(
        children: [
          AudioProgressBar(
            addPostProvider.progressNotifier,
            addPostProvider.seek
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                ),
                child: UserImage(doc: currentUserDoc,)
              ),
              Container(
                width: size.width * 0.55,
                child: Column(
                  children: [
                    // Text(userName),
                    // Text(title)
                    Text(
                      currentUserDoc['userName'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    ValueListenableBuilder<String>(
                      valueListenable: addPostProvider.postTitleNotifier,
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
                      addPostProvider.playButtonNotifier,
                      (){
                        addPostProvider.play();
                      },
                      (){
                        addPostProvider.pause();
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
