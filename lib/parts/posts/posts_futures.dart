import 'package:cloud_firestore/cloud_firestore.dart';

Future like(String uid, DocumentSnapshot postDoc) async {
  try {
    await FirebaseFirestore.instance
    .collection('likes')
    .add({
      'uid': uid,
      'postId': postDoc['postId'],
    });
  } catch(e) {
    print(e.toString());
  }
}

Future preservate(String uid, DocumentSnapshot postDoc) async {
  try {
    await FirebaseFirestore.instance
    .collection('preservations')
    .add({
      'uid': uid,
      'postId': postDoc['postId'],
    });
  } catch(e) {
    print(e.toString());
  }
}