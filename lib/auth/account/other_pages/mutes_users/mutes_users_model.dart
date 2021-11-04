// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final mutesUsersProvider = ChangeNotifierProvider(
  (ref) => MutesUsersModel()
);

class MutesUsersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  late SharedPreferences prefs;
  List<DocumentSnapshot> mutesUserDocs = [];

  MutesUsersModel() {
    init();
  }

  Future<void> init() async {
    startLoading();
    final mutesUids = await setPrefs();
    await getMutesUsersInfo(mutesUids);
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

  Future<List<String>> setPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final mutesUids = prefs.getStringList('mutesUids') ?? [];
    return mutesUids;
  }

  Future<void> getMutesUsersInfo(List<String> mutesUids) async {
    if (mutesUids.isNotEmpty) {
      await FirebaseFirestore.instance
      .collection('users')
      .where('uid',whereIn: mutesUids)
      .get()
      .then((qshot) {
        qshot.docs.forEach((DocumentSnapshot doc) {
          mutesUserDocs.add(doc);
        });
        notifyListeners();
      });
    }
  }

  void removeMutesUserDoc(String passiveUid) {
    mutesUserDocs.removeWhere((mutesUserDoc) => mutesUserDoc['uid'] ==  passiveUid);
    notifyListeners();
  }

  Future unMuteUser(List<dynamic> mutesUids,String passiveUid,DocumentSnapshot currentUserDoc) async {
    removeMutesUserDoc(passiveUid);
    mutesUids.remove(passiveUid);
    await FirebaseFirestore.instance
    .doc(currentUserDoc.id)
    .update({
      'mutesUids': mutesUids,
    });
  }

}