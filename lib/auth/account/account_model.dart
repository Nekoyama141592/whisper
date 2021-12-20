// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;

final accountProvider = ChangeNotifierProvider(
  (ref) => AccountModel()
);

enum WhichState {
  initialValue,
  updateEmail,
  updatePassword,
  deleteUser     
}

class AccountModel extends ChangeNotifier {
  
  User? currentUser;

  AccountModel() {
    init();
  }

  void init() {
    currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  WhichState whichState = WhichState.initialValue;
  String password = '';
  
  Future reauthenticateWithCredential (BuildContext context,User? currentUser,DocumentSnapshot currentUserDoc)  async {
    
    currentUser = FirebaseAuth.instance.currentUser;
    final String email = currentUser!.email!;
    final credential = EmailAuthProvider.credential(email: email, password: password);

    try {
      await currentUser.reauthenticateWithCredential(credential);
      switch(whichState) {
        case WhichState.initialValue:
        break;
        case WhichState.updatePassword:
          routes.toUpdatePassword(context, currentUser);
        break;
        case WhichState.updateEmail:
          routes.toUpdateEmailPage(context, currentUser);
        break;
        case WhichState.deleteUser:
          showDeleteUserDialog(context, currentUserDoc);
        break;
      }
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'invalid-email':
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('そのメールアドレスは不敵です')));
        break;
        case 'wrong-password':
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('パスワードが違います')));
        break;
      }
    }
  }

  void showDeleteUserDialog(BuildContext context,DocumentSnapshot currentUserDoc) {
    showCupertinoDialog(context: context, builder: (context) {
      return CupertinoAlertDialog(
        title: Text('ユーザー削除'),
        content: Text('一度削除したら、復元はできません。本当に削除しますか？'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Ok'),
            isDestructiveAction: true,
            onPressed: () async {
              if (currentUser!.uid == currentUserDoc['uid']) {
                await deletePostsOfCurrentUser();
                await deleteReplysOfCurrentUser();
                await deleteCommentsOfCurrentUser();
                await deleteUserFromFireStoreAndFirebaseAuth(context, currentUserDoc);
              }
            },
          )
        ],
      );
    });
  }

  Future deletePostsOfCurrentUser() async {
    await FirebaseFirestore.instance
    .collection('posts')
    .where('uid',isEqualTo: currentUser!.uid)
    .get()
    .then((qshot) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final docs = qshot.docs;
      int index = 0;
      docs.forEach((DocumentSnapshot doc) async {
        if ((index + 1) % 500 == 0) {
          // commit by 500 and initialize batch instance
          await batch.commit();
          batch = FirebaseFirestore.instance.batch();
        }
        batch.delete(doc.reference);
        index++;
      });
      // last commit
      return batch.commit();
    });
  }
  
  Future deleteReplysOfCurrentUser() async {
    await FirebaseFirestore.instance
    .collection('replys')
    .where('uid',isEqualTo: currentUser!.uid)
    .get()
    .then((qshot) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final docs = qshot.docs;
      int index = 0;
      docs.forEach((DocumentSnapshot doc) async {
        if ((index + 1) % 500 == 0) {
          // commit by 500 and initialize batch instance
          await batch.commit();
          batch = FirebaseFirestore.instance.batch();
        }
        batch.delete(doc.reference);
        index++;
      });
      // last commit
      return batch.commit();
    });
  }
  Future deleteCommentsOfCurrentUser() async {
    await FirebaseFirestore.instance
    .collection('comments')
    .where('uid',isEqualTo: currentUser!.uid)
    .get()
    .then((qshot) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final docs = qshot.docs;
      int index = 0;
      docs.forEach((DocumentSnapshot doc) async {
        if ((index + 1) % 500 == 0) {
          // commit by 500 and initialize batch instance
          await batch.commit();
          batch = FirebaseFirestore.instance.batch();
        }
        batch.delete(doc.reference);
        index++;
      });
      // last commit
      return batch.commit();
    });
  }
  Future deleteUserFromFireStoreAndFirebaseAuth(BuildContext context,DocumentSnapshot currentUserDoc) async {
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .delete()
    .then((_) async {
      try {
        await currentUser!.delete();
        Navigator.pop(context);
        routes.toIsFinishedPage(context, 'ユーザーを消去しました');
      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('何らかのエラーが発生しました')));
      }
    });
  }

  void showSignOutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context, 
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('ログアウト'),
          content: Text('ログアウトしますか？'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Ok'),
              isDestructiveAction: true,
              onPressed: () async {
                await signOut(context);
              },
            )
          ],
        );
      }
    );
  }

  Future signOut(BuildContext context) async {
    Navigator.pop(context);
    await FirebaseAuth.instance.signOut();
    routes.toIsFinishedPage(context,'ログアウトしました');
  }
}