// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// models
import 'package:whisper/main_model.dart';

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
  
  Future <void>reauthenticateWithCredential ({required BuildContext context,required User? currentUser,required MainModel mainModel})  async {
    
    currentUser = FirebaseAuth.instance.currentUser;
    final String email = currentUser!.email!;
    final credential = EmailAuthProvider.credential(email: email, password: password);

    try {
      await currentUser.reauthenticateWithCredential(credential);
      switch(whichState) {
        case WhichState.initialValue:
        break;
        case WhichState.updatePassword:
          routes.toUpdatePassword(context: context, currentUser: currentUser );
        break;
        case WhichState.updateEmail:
          routes.toUpdateEmailPage(context, currentUser);
        break;
        case WhichState.deleteUser:
          showDeleteUserDialog(context: context, mainModel: mainModel);
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

  void showDeleteUserDialog({ required BuildContext context, required MainModel mainModel }) {
    final currentWhisperUser = mainModel.currentWhisperUser;
    voids.showCupertinoDialogue(context: context, title: 'ユーザー削除', content: '一度削除したら、復元はできません。本当に削除しますか？', action: () async {
      if (currentUser!.uid == mainModel.currentWhisperUser.uid) {
        Navigator.pop(context);
        routes.toIsFinishedPage(context: context,title: 'ユーザーを消去しました',text: 'ユーザーも投稿もコメントも削除されました。お疲れ様でした');
        await deleteStorage(mainModel: mainModel);
        await deletePostsOfCurrentUser();
        await deleteReplysOfCurrentUser();
        await deleteCommentsOfCurrentUser();
        await deleteUserFromFireStoreAndFirebaseAuth(context: context, currentWhisperUser: currentWhisperUser);
      }
    });
  }

  Future<void> deleteStorage({ required MainModel mainModel }) async {
    await postParentRef(mainModel: mainModel).delete();
    await postImageParentRef(mainModel: mainModel).delete();
    await userImageParentRef(uid: mainModel.currentUser!.uid).delete();
  }

  Future<void> deletePostsOfCurrentUser() async {
    await FirebaseFirestore.instance
    .collection(postsFieldKey).where(uidFieldKey,isEqualTo: currentUser!.uid).get()
    .then((qshot) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final docs = qshot.docs;
      int index = 0;
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) async {
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
  
  Future<void> deleteReplysOfCurrentUser() async {
    await FirebaseFirestore.instance
    .collection(replysFieldKey)
    .where(uidFieldKey,isEqualTo: currentUser!.uid)
    .get()
    .then((qshot) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final docs = qshot.docs;
      int index = 0;
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) async {
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
  Future<void> deleteCommentsOfCurrentUser() async {
    await FirebaseFirestore.instance
    .collection(commentsFieldKey)
    .where(uidFieldKey,isEqualTo: currentUser!.uid)
    .get()
    .then((qshot) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      final docs = qshot.docs;
      int index = 0;
      docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) async {
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
  Future<void> deleteUserFromFireStoreAndFirebaseAuth({ required BuildContext context, required WhisperUser currentWhisperUser}) async {
    await FirebaseFirestore.instance.collection(usersFieldKey).doc(currentWhisperUser.uid).delete().then((_) async {
      try {
        await currentUser!.delete();
      } catch(e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('何らかのエラーが発生しました')));
      }
    });
  }

  void showSignOutDialog(BuildContext context) {
    voids.showCupertinoDialogue(context: context, title: 'ログアウト', content: 'ログアウトしますか?', action: () async { voids.signOut(context); });
  }

}