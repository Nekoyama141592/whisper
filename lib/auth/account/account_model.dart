// material
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
  
  Future reauthenticateWithCredential (BuildContext context,User? currentUser)  async {
    
    currentUser = FirebaseAuth.instance.currentUser;
    final email = currentUser!.email;
    final credential = EmailAuthProvider.credential(email: email!, password: password);
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    try {
      await user!.reauthenticateWithCredential(credential);
      if (whichState == WhichState.updatePassword) {
        routes.toUpdatePassword(context, currentUser);
      } else if (whichState == WhichState.updateEmail) {
        routes.toUpdateEmailPage(context, currentUser);
      }
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'user-mismatch':
        print('それは今、お使いのアカウントではありません');
        break;
        case 'user-not-found':
        print('そのようなユーザーは見つかりません');
        break;
        case 'invalid-email':
        print('そのメールアドレスは運営によって無効化されています');
        break;
        case 'invalid-credential':
        print('invalid-credential');
        break;
        case 'wrong-password':
        print('passwordが違います');
        break;
      }
    }
  }

  void showSignOutDialog(BuildContext context) {
    showDialog(
      context: context, 
      builder: (_) {
        return AlertDialog(
          title: Text('ログアウト'),
          content: Text('ログアウトしますか？'),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text('cancel')),
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