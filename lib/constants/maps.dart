// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/bookmark_label/bookmark_label.dart';

Map<String,dynamic> returnTokenToSearch({ required List<String> searchWords }) {
  Map<String,dynamic> tokenToSearch = {};
  searchWords.forEach((word) {
    tokenToSearch[word] = true;
  });
  return tokenToSearch;
}

Map<String,dynamic> returnFirstBookmarkLabel({ required Timestamp now , required String uid, required String bookmarkLabelId }) {
  return BookmarkLabel(
    createdAt: now,
    label: unNamedString, 
    bookmarkLabelId: bookmarkLabelId,
    bookmarks: [],
    uid: uid, 
    updatedAt: now,
  ).toJson();
}