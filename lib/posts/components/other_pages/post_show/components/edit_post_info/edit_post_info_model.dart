// dart  
import 'dart:io';
// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/maps.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart';
import 'package:whisper/domain/post_update_log/post_update_log.dart';
import 'package:whisper/main_model.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
// pagas
import 'package:whisper/links/links_page.dart';

final editPostInfoProvider = ChangeNotifierProvider(
  (ref) => EditPostInfoModel()
);

class EditPostInfoModel extends ChangeNotifier {
  
  bool isEditing = false;
  String title = '';
  // image
  bool isCropped = false;
  XFile? xFile;
  File? croppedFile;
  final whisperLinksNotifier = ValueNotifier<List<WhisperLink>>([]);

  void reload() {
    notifyListeners();
  }

  Future showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      await cropImage();
    }
    notifyListeners();
  }

  Future cropImage() async {
    isCropped = false;
    croppedFile = null;
    croppedFile = await returnCroppedFile(xFile: xFile);
    if (croppedFile != null) {
      isCropped = true;
      notifyListeners();
    }
  }

  Future<String> uploadImage({ required MainModel mainModel,required String postId }) async {
    final thisPostImageName = returnStoragePostImageName();
    final ref = returnPostImageChildRef(mainModel: mainModel,postImageName: thisPostImageName,postId: postId);
    await putImage(imageRef: ref, file: croppedFile! );
    final String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> updatePostInfo({ required Post whisperPost , required MainModel mainModel, required BuildContext context }) async {
    if (title.length > maxSearchLength ) {
      maxSearchLengthAlert(context: context, isUserName: false );
    } else if (whisperLinksNotifier.value.length > maxLinksLength) {
      alertMaxLinksLength(context: context);
    } else {
      // final String imageURL = croppedFile == null ? whisperPost.imageURLs.first : await uploadImage(mainModel: mainModel,postId: whisperPost.postId );
      if (croppedFile != null) {
        whisperPost.imageURLs = [await uploadImage(mainModel: mainModel,postId: whisperPost.postId )];
      }
      if (title.isNotEmpty) {
        whisperPost.title = title;
        whisperPost.searchToken = returnSearchToken(searchWords: returnSearchWords(searchTerm: title)  );
      }
      whisperPost.links = whisperLinksNotifier.value.map((e) => e.toJson()).toList();
      try{
        final PostUpdateLog postUpdateLog = PostUpdateLog(commentsState: whisperPost.commentsState, country: whisperPost.country, description: whisperPost.description, genre: whisperPost.genre, hashTags: whisperPost.hashTags, imageURLs: whisperPost.imageURLs, isPinned: whisperPost.isPinned, language: whisperPost.language, links: whisperPost.links, postState: whisperPost.postState, postId: whisperPost.postId, tagAccountNames: whisperPost.tagAccountNames, searchToken: whisperPost.searchToken, title: whisperPost.title, uid: whisperPost.uid, updatedAt: Timestamp.now() );
        await returnPostUpdateLogDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, postUpdateLogId: generatePostUpdateLogId() ).set(postUpdateLog.toJson());
        isEditing = false;
        notifyListeners();
        title = '';
        whisperLinksNotifier.value = [];
      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('なんらかのエラーが発生しました')));
      }
    }
  }

  void init({ required BuildContext context  ,required List<Map<String,dynamic>> linkMaps  }) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LinksPage(
      whisperLinksNotifier: whisperLinksNotifier,
    ) ));
    whisperLinksNotifier.value = [];
    whisperLinksNotifier.value = linkMaps.map((e) => fromMapToWhisperLink(whisperLink: e) ).toList();
    notifyListeners();
  }
  
}