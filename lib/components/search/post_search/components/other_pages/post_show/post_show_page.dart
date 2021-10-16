// material
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/components/search/post_search/components/audio_window/components/audio_state_design.dart';
import 'package:whisper/components/search/post_search/components/audio_window/components/current_song_user_name.dart';
import 'package:whisper/components/search/post_search/components/other_pages/post_show/components/edit_post_info/search_edit_post_info_screen.dart';
import 'package:whisper/components/search/post_search/components/audio_window/components/current_song_title.dart';
import 'package:whisper/components/search/post_search/components/details/square_post_image.dart';
import 'package:whisper/components/search/post_search/components/post_buttons/post_buttons.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/post_search_model.dart';
import 'package:whisper/components/search/post_search/components/other_pages/post_show/components/edit_post_info/search_edit_post_info_model.dart';

class PostShowPage extends ConsumerWidget {
  
  const PostShowPage({
    Key? key,
    required this.speedNotifier,
    required this.speedControll,
    required this.mainModel,
    required this.postSearchModel
  }) : super(key: key);

  final ValueNotifier<double> speedNotifier;
  final void Function()? speedControll;
  final MainModel mainModel;
  final PostSearchModel postSearchModel;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final searchEditPostInfoModel = watch(searchEditPostInfoProvider);
    final currentSongMap = postSearchModel.currentSongMapNotifier.value;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: false,
      body: SafeArea(
        child: searchEditPostInfoModel.isEditing ?
        SearchEditPostInfoScreen(currentUserDoc: mainModel.currentUserDoc, currentSongMap: currentSongMap, searchEditPostInfoModel: searchEditPostInfoModel)
        : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    color: Theme.of(context).focusColor,
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                  ),
                  SizedBox(width: size.width * 0.38),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SquarePostImage(currentSongMapNotifier: postSearchModel.currentSongMapNotifier),
                    CurrentSongUserName(currentSongMapNotifier: postSearchModel.currentSongMapNotifier),
                    SizedBox(height: 10.0),
                    CurrentSongTitle(currentSongMapNotifier: postSearchModel.currentSongMapNotifier),
                    SizedBox(height: 10.0),
                    PostButtons(currentSongMapNotifier: postSearchModel.currentSongMapNotifier, mainModel: mainModel, searchEditPostInfoModel: searchEditPostInfoModel),
                    SizedBox(height: 10.0),
                    AudioStateDesign(speedNotifier: speedNotifier, speedControll: speedControll, mainModel: mainModel, postSearchModel: postSearchModel)
                    
                  ],
                ),
              ),
            ),
            
          ],
        )
      ),
    );
  }
}