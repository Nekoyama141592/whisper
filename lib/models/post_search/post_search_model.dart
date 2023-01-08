// material
import 'package:flutter/material.dart';
// package
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/abstract_models/posts_model.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/bools.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/l10n/l10n.dart';
import 'package:whisper/main_model.dart';

final postSearchProvider = ChangeNotifierProvider(
  (ref) => PostSearchModel()
);

class PostSearchModel extends PostsModel {

  String searchTerm = '';
  bool isFirstSearch = false;

  PostSearchModel() : super(postType: PostType.postSearch) {
    init();
  }

  Future<void> init() async {
    audioPlayer = AudioPlayer();
    prefs = await SharedPreferences.getInstance();
    await super.setSpeed();
  }

  bool isValidReadPost({ required Map<String,dynamic> map, required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesPostIds}) {
    final whisperPost = fromMapToPost(postMap: map);
    return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids,uid: whisperPost.uid) && !mutesPostIds.contains(whisperPost.postId);
  }

  Future<void> search({ required BuildContext context ,required MainModel mainModel, required WhisperUser passiveWhisperUser }) async {
    final L10n l10n = returnL10n(context: context)!;
    if (searchTerm.length > maxSearchLength ) {
      showBasicFlutterToast(context: context, msg: l10n.searchLimitMsg(maxSearchLength.toString()) );
    } else if (searchTerm.isNotEmpty) {
      startLoading();
      posts = [];
      final List<String> searchWords = returnSearchWords(searchTerm: searchTerm);
      final Query<Map<String,dynamic>> query = returnSearchQuery(colRef: returnPostsColRef(postCreatorUid: passiveWhisperUser.uid),searchWords: searchWords);
      await processBasicPosts(query: query, muteUids: mainModel.muteUids, blockUids: mainModel.blockUids, mutePostIds: mainModel.mutePostIds);
      if (isFirstSearch == false) {
        super.listenForStates();
        isFirstSearch = true;
      }
      endLoading();
    }
  }

  Future<void> onReload({ required BuildContext context ,required MainModel mainModel, required WhisperUser passiveWhisperUser }) async {
    startLoading();
    await search(context: context, mainModel: mainModel, passiveWhisperUser: passiveWhisperUser);
    endLoading();
  }

}