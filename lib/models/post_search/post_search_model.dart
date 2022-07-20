// material
import 'package:flutter/material.dart';
// package
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/l10n/l10n.dart';
import 'package:whisper/main_model.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final postSearchProvider = ChangeNotifierProvider(
  (ref) => PostSearchModel()
);

class PostSearchModel extends ChangeNotifier{

  String searchTerm = '';
  bool isLoading = false;
  bool isFirstSearch = false;
   // just_audio
  late AudioPlayer audioPlayer;
  List<AudioSource> afterUris = [];
  List<DocumentSnapshot<Map<String,dynamic>>> results = [];
   // notifiers
  final currentWhisperPostNotifier = ValueNotifier<Post?>(null);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);
  // enum
  final PostType postType = PostType.postSearch;

  PostSearchModel() {
    init();
  }

  Future<void> init() async {
    audioPlayer = AudioPlayer();
    prefs = await SharedPreferences.getInstance();
    await voids.setSpeed(audioPlayer: audioPlayer,prefs: prefs,speedNotifier: speedNotifier);
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
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
      results = [];
      final List<String> searchWords = returnSearchWords(searchTerm: searchTerm);
      final Query<Map<String,dynamic>> query = returnPostSearchQuery(postCreatorUid: passiveWhisperUser.uid,searchWords: searchWords);
      await processBasicPosts(query: query, posts: results, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: mainModel.muteUids, blockUids: mainModel.blockUids, mutePostIds: mainModel.mutePostIds);
      if (isFirstSearch == false) {
        voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentWhisperPostNotifier: currentWhisperPostNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
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

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

}