// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// package
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
// import 'package:algolia/algolia.dart';
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/voids.dart' as voids;
// import 'package:whisper/components/search/constants/AlgoliaApplication.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final postSearchProvider = ChangeNotifierProvider(
  (ref) => PostSearchModel()
);

class PostSearchModel extends ChangeNotifier{

  // final Algolia algoliaApp = AlgoliaApplication.algolia;
  String searchTerm = '';
  bool isLoading = false;
   // just_audio
  late AudioPlayer audioPlayer;
  List<AudioSource> afterUris = [];
  List<DocumentSnapshot<Map<String,dynamic>>> results = [];
   // notifiers
  final currentSongMapNotifier = ValueNotifier<Map<String,dynamic>>({});
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

  bool isValidReadPost({ required Map<String,dynamic> map, required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required List<dynamic> mutesPostIds}) {
    final whisperPost = fromMapToPost(postMap: map);
    return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, map: map) && !mutesPostIds.contains(whisperPost.postId);
  }

  Future operation({ required BuildContext context ,required List<dynamic> mutesUids, required List<String> mutesPostIds, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s}) async {
    startLoading();
    await search(context: context, mutesUids: mutesUids, blocksUids: blocksUids);
    voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentSongMapNotifier: currentSongMapNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
    endLoading();
  }

  Future<void> search({ required BuildContext context ,required List<dynamic> mutesUids, required List<dynamic> blocksUids}) async {
    if (searchTerm.length < 64) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('64文字未満で検索してください')));
    } else {
      startLoading();
      final List<String> searchWords = returnSearchWords(searchTerm: searchTerm);
      final Query<Map<String,dynamic>> query = returnSearchQuery(collectionKey: usersKey, searchWords: searchWords);
      await processBasicDocs(query: query, docs: results);
      endLoading();
    }
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  // Future search({required List<dynamic> mutesUids, required List<String> mutesPostIds, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required blocksIpv6s}) async {
  //   results = [];
  //   AlgoliaQuery query = algoliaApp.instance.index('Posts').query(searchTerm);
  //   AlgoliaQuerySnapshot querySnap = await query.getObjects();
  //   List<AlgoliaObjectSnapshot> hits = querySnap.hits;
  //   hits.forEach((hit) {
  //     final Map<String,dynamic> map = hit.data;
  //     if ( isValidReadPost(map: map, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, mutesPostIds: mutesPostIds) ) {
  //       results.add(map);
  //       final whisperPost = fromMapToPost(postMap: map);
  //       Uri song = Uri.parse(whisperPost.audioURL);
  //       UriAudioSource source = AudioSource.uri(song, tag: map);
  //       afterUris.add(source);
  //     }
  //   });
  //   if (afterUris.isNotEmpty) {
  //     ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
  //     await audioPlayer.setAudioSource(playlist);
  //   }
  // }
}