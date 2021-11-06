// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/counts.dart';
// components
import 'package:whisper/details/rounded_button.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final userShowProvider = ChangeNotifierProvider(
  (ref) => UserShowModel()
);

enum SortState { byLikedUidsCount, byNewestFirst,byOldestFirst }

class UserShowModel extends ChangeNotifier {

  bool isLoading = false;
  User? currentUser;
  
  // notifiers
  final currentSongMapNotifier = ValueNotifier<Map<String,dynamic>>({});
  final currentSongMapCommentsNotifier = ValueNotifier<List<dynamic>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  // just_audio
  late AudioPlayer audioPlayer;
  List<AudioSource> afterUris = [];
  // cloudFirestore
  List<String> postIds = [];
  List<DocumentSnapshot> userShowDocs = [];
  // refresh
  int refreshIndex = defaultRefreshIndex;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // Edit profile
  bool isEditing = false;
  String userName = '';
  String description = '';
  String link = '';
  // post
  String downloadURL = '';
  bool isCropped = false;
  XFile? xfile;
  File? croppedFile;
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);


  UserShowModel() {
    init();
  }

  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    setCurrentUser();
    await getPosts();
    await setPrefs();
    setSpeed();
    listenForStates();
    endLoading();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
  }

 void sortCommentsByLikesUidsCount(BuildContext context) {
    List<dynamic> comments =  currentSongMapCommentsNotifier.value;
    comments.sort((a,b) => b['likesUids'].length.compareTo(a['likesUids'].length ));
    currentSongMapCommentsNotifier.value = comments;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('左下から並び替えを実行'), duration: Duration(seconds: 1 ),) );
  }

  void sortCommentsByNewestFirst(BuildContext context) {
    List<dynamic> comments =  currentSongMapCommentsNotifier.value;
    comments.sort((a,b) => b['createdAt'].toDate().compareTo(a['createdAt'].toDate() ));
    currentSongMapCommentsNotifier.value = comments;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('左下から並び替えを実行'), duration: Duration(seconds: 1),) );
  }

  void sortCommentsByOldestFirst(BuildContext context) {
    List<dynamic> comments =  currentSongMapCommentsNotifier.value;
    comments.sort((a,b) => a['createdAt'].toDate().compareTo(b['createdAt'].toDate() ));
    currentSongMapCommentsNotifier.value = comments;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('左下から並び替えを実行'), duration: Duration(seconds: 1),) );
  }


  void showSortDialogue(BuildContext context) {
    showCupertinoDialog(
      context: context, 
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('並び替え',style: TextStyle(fontWeight: FontWeight.bold)),
          message: Text('コメントを並び替えます',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                sortCommentsByLikesUidsCount(context);
              }, 
              child: Text(
                'いいね順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                sortCommentsByNewestFirst(context);
              }, 
              child: Text(
                '新しい順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                sortCommentsByOldestFirst(context);
              }, 
              child: Text(
                '古い順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: Text(
                'キャンセル',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
          ],
        );
      }
    );
  }

  void showSortPostDocsDialogue(BuildContext context,String uid) {
    showCupertinoDialog(
      context: context, 
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('並び替え',style: TextStyle(fontWeight: FontWeight.bold)),
          message: Text('投稿を並び替えます',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                userShowDocs = [];
                afterUris = [];
                refreshIndex = defaultRefreshIndex;
                // getDocsFromFirestore
                // makeQuery
                refreshIndex = afterUris.length + defaultRefreshIndex;
              }, 
              child: Text(
                'いいね順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                userShowDocs = [];
                afterUris = [];
                refreshIndex = defaultRefreshIndex;
                // getDocsFromFirestore
                // makeQuery
                refreshIndex = afterUris.length + defaultRefreshIndex;
              }, 
              child: Text(
                '新しい順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                userShowDocs = [];
                afterUris = [];
                refreshIndex = defaultRefreshIndex;
                // getDocsFromFirestore
                // makeQuery
                refreshIndex = afterUris.length + defaultRefreshIndex;
              }, 
              child: Text(
                '古い順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () { Navigator.pop(context); }, 
              child: Text(
                'キャンセル',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
          ],
        );
      }
    );
  } 

  void reload() {
    notifyListeners();
  }

  Future initAudioPlayer(int i) async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
    await audioPlayer.setAudioSource(playlist,initialIndex: i);
  }

  Future onRefresh() async {
    await getNewUserShowPosts();
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future getNewUserShowPosts() async {
    QuerySnapshot<Map<String, dynamic>> newSnapshots = await FirebaseFirestore.instance
    .collection('posts')
    .where('uid',isEqualTo: currentUser!.uid)
    .orderBy('createdAt',descending: true)
    .endBeforeDocument(userShowDocs[0])
    .limit(oneTimeReadCount)
    .get();
    // Sort by oldest first
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
    docs.sort((a,b) => a['createdAt'].compareTo(b['createdAt']));
    // Insert at the top
    docs.forEach((DocumentSnapshot? doc) {
      userShowDocs.insert(0, doc!);
      Uri song = Uri.parse(doc['audioURL']);
      UriAudioSource source = AudioSource.uri(song, tag: doc);
      afterUris.insert(0, source);
    });
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist);
    }
    refreshIndex = afterUris.length + defaultRefreshIndex;
  }

  Future onLoading() async {
    await getPosts();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future getPosts() async {
    try {
      if (refreshIndex == defaultRefreshIndex) {
        await FirebaseFirestore.instance
        .collection('posts')
        .where('uid',isEqualTo: currentUser!.uid)
        .orderBy('createdAt',descending: true)
        .limit(oneTimeReadCount)
        .get()
        .then((qshot) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
          docs.sort((a,b) => b['createdAt'].compareTo(a['createdAt']));
          docs.forEach((DocumentSnapshot? doc) {
            userShowDocs.add(doc!);
            Uri song = Uri.parse(doc['audioURL']);
            UriAudioSource source = AudioSource.uri(song, tag: doc);
            afterUris.add(source);
          });
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist);
        }
      } else {
        await FirebaseFirestore.instance
        .collection('posts')
        .where('uid',isEqualTo: currentUser!.uid)
        .orderBy('createdAt',descending: true)
        .startAfterDocument(userShowDocs[refreshIndex])
        .limit(oneTimeReadCount)
        .get()
        .then((qshot) {
          List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
          docs.sort((a,b) => b['createdAt'].compareTo(a['createdAt']));
          docs.forEach((DocumentSnapshot? doc) {
            userShowDocs.add(doc!);
            Uri song = Uri.parse(doc['audioURL']);
            UriAudioSource source = AudioSource.uri(song, tag: doc);
            afterUris.add(source);
          });
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: refreshIndex);
          
        }
      }
    } catch(e) {
      print(e.toString());
    }
    refreshIndex = afterUris.length + defaultRefreshIndex;
    notifyListeners();
  }

  Future showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      await cropImage();
    }
    notifyListeners();
  }

  Future cropImage() async {
    isCropped = false;
    croppedFile = null;
    croppedFile = await ImageCropper.cropImage(
      sourcePath: xfile!.path,
      aspectRatioPresets: Platform.isAndroid ?
      [
        CropAspectRatioPreset.square,
      ]
      : [
        // CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: kPrimaryColor,
        toolbarWidgetColor: Colors.white,
        // initAspectRatio: CropAspectRatioPreset.original,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Cropper',
      )
    );
    if (croppedFile != null) {
      isCropped = true;
    }
    notifyListeners();
  }

  Future<String> uploadImage(DocumentSnapshot currentUserDoc) async {
    final String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    if (userName.isEmpty) {
      print('userNameを入力してください');
    }
    try {
      await FirebaseStorage.instance
      .ref()
      .child('users')
      .child(currentUserDoc['uid'] + dateTime + '.jpg')
      .putFile(croppedFile!);
      downloadURL = await FirebaseStorage.instance
      .ref()
      .child('users')
      .child(currentUserDoc['uid'] + dateTime + '.jpg')
      .getDownloadURL();
    } catch(e) {
      print(e.toString());
    }
    return downloadURL;
  }


  void play(List<dynamic> readPostIds,List<dynamic> readPosts,DocumentSnapshot currentUserDoc)  {
    audioPlayer.play();
    notifyListeners();
    final postId = currentSongMapNotifier.value['postId'];
    if (!readPostIds.contains(postId)) {
      final map = {
        'createdAt': Timestamp.now(),
        'postId': postId,
      };
      readPosts.add(map);
      FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'readPosts': readPosts,
      });
    }
  }


  void pause() {
    audioPlayer.pause();
    notifyListeners();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }
  // showPage
  void onRepeatButtonPressed() {
    repeatButtonNotifier.nextState();
    switch (repeatButtonNotifier.value) {
      case RepeatState.off:
        audioPlayer.setLoopMode(LoopMode.off);
        break;
      case RepeatState.repeatSong:
        audioPlayer.setLoopMode(LoopMode.one);
        break;
      case RepeatState.repeatPlaylist:
        audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  void onPreviousSongButtonPressed() {
    audioPlayer.seekToPrevious();
  }

  void onNextSongButtonPressed() {
    audioPlayer.seekToNext();
  }

  Future speedControll() async {
    if (speedNotifier.value == 4.0) {
      speedNotifier.value = 1.0;
      await audioPlayer.setSpeed(speedNotifier.value);
      await prefs.setDouble('speed', speedNotifier.value);
    } else {
      speedNotifier.value += 0.5;
      await audioPlayer.setSpeed(speedNotifier.value);
      await prefs.setDouble('speed', speedNotifier.value);
    }
  }

  Future setPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setSpeed() {
    speedNotifier.value = prefs.getDouble('speed') ?? 1.0;
    audioPlayer.setSpeed(speedNotifier.value);
  }

  void listenForStates() {
    listenForChangesInPlayerState();
    listenForChangesInPlayerPosition();
    listenForChangesInBufferedPosition();
    listenForChangesInTotalDuration();
    listenForChangesInSequenceState();
  }
  void listenForChangesInPlayerState() {
    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
    });
  }

  void listenForChangesInPlayerPosition() {
    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInBufferedPosition() {
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInTotalDuration() {
    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void listenForChangesInSequenceState() {
    audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      // update current song doc
      final currentItem = sequenceState.currentSource;
      final DocumentSnapshot<Map<String,dynamic>>? currentSongDoc = currentItem?.tag;
      currentSongMapNotifier.value = currentSongDoc!.data() as Map<String,dynamic>;
      currentSongMapCommentsNotifier.value = currentSongDoc.data()!['comments'];
      // update playlist
      final playlist = sequenceState.effectiveSequence;
      // playlist.map((item) {
      //   currentSongDocs.add(item.tag);
      // });
      // update shuffle mode
      isShuffleModeEnabledNotifier.value = 
      sequenceState.shuffleModeEnabled;
      // update previous and next buttons
      if (playlist.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true; 
      } else {
        isFirstSongNotifier.value = playlist.first == currentItem;
        isLastSongNotifier.value = playlist.last == currentItem;
      }
    });
    notifyListeners();
  }

  void onEditButtonPressed(DocumentSnapshot currentUserDoc) {
    userName = currentUserDoc['userName'];
    description = currentUserDoc['description'];
    link = currentUserDoc['link'];
    isEditing = true;
    notifyListeners();
  }

  Future updateUserInfo(BuildContext context,DocumentSnapshot currentUserDoc) async {

    final String downloadURL = croppedFile == null ? currentUserDoc['imageURL'] : await uploadImage(currentUserDoc);
    if (downloadURL.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('エラーが発生。もう一度待ってからお試しください')));
    } else {
      try {
      await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserDoc.id)
        .update({
          'description': description,
          'link': link,
          'updatedAt': Timestamp.now(),
          'userName': userName,
        });
        notifyListeners();
      } catch(e) {
        print(e.toString());
      }
    }
  }

  Future onSaveButtonPressed(BuildContext context,DocumentSnapshot currentUserDoc) async {
    await updateUserInfo(context,currentUserDoc);
    isEditing = false;
  }

   void onDeleteButtonPressed(BuildContext context,DocumentSnapshot postDoc,DocumentSnapshot currentUserDoc,int i) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('投稿を削除'),
          content: Text('投稿を削除しますか？'),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text('cancel',style: TextStyle(color: Theme.of(context).focusColor,fontWeight: FontWeight.bold),)),
            RoundedButton(
              text: 'OK', 
              widthRate: 0.2, 
              verticalPadding: 20.0, 
              horizontalPadding: 10.0, 
              press: () async { await delete(context, postDoc, currentUserDoc, i); }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).highlightColor
            )
          ],
        );
      }
    );
  }

  
  Future delete(BuildContext context,DocumentSnapshot postDoc, DocumentSnapshot currentUserDoc,int i) async {
    if (currentUserDoc['uid'] != postDoc['uid']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたにはその権限がありません')));
    } else {
      try {
        AudioSource source = afterUris[i];
        afterUris.remove(source);
        userShowDocs.remove(postDoc);
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: i);
        }
        refreshIndex = afterUris.length -1;
        notifyListeners();
        await FirebaseFirestore.instance
        .collection('posts')
        .doc(postDoc.id)
        .delete();
      } catch(e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('何らかのエラーが発生しました')));
      }
    }
  }

}