// material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/rounded_button.dart';

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
    final email = currentUser!.email;
    final credential = EmailAuthProvider.credential(email: email!, password: password);
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    try {
      await user!.reauthenticateWithCredential(credential);
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
    showDialog(
      context: context, 
      builder: (_) {
        return AlertDialog(
          title: Text('ユーザー削除'),
          content: Text('一度削除したら、復元はできません。本当に削除しますか？'),
          actions: [
            RoundedButton(
              text: 'OK', 
              widthRate: 0.2, 
              verticalPadding: 20.0, 
              horizontalPadding: 10.0, 
              press: () async {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser!.uid == currentUserDoc['uid']) {
                  await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserDoc.id)
                  .delete().then((_) {
                    routes.toLoginpage(context);
                  });
                  await currentUser.delete();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('何らかのエラーが発生しました')));
                }
              }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).highlightColor
            )
          ],
        );
      }
    );
  }

  void showSignOutDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (_) {
        return AlertDialog(
          title: Text('ログアウト'),
          content: Text('ログアウトしますか？'),
          actions: [
            RoundedButton(
              text: 'OK', 
              widthRate: 0.2, 
              verticalPadding: 20.0, 
              horizontalPadding: 10.0, 
              press: () async { await signOut(context); }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).highlightColor
            )
          ],
        );
      }
    );
  }
  Future signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    routes.toLoginpage(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('一度、Whisperのタブを切るのをおすすめします'))
    );
  }
}