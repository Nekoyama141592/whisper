// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final verifyPasswordResetProvider = ChangeNotifierProvider((ref) => VerifyPasswordResetModel());

class VerifyPasswordResetModel extends ChangeNotifier {
  
  String email = '';

  Future sendPasswordResetEmail (context) async {
    final instance = FirebaseAuth.instance;
    try{
      await instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(email + 'にメールを送りました')));
    } on FirebaseAuthException catch(e) {
      print(e.toString());
      switch(e.code) {
        case 'auth/invalid-email':
        print('メールアドレスが有効ではありません');
        break;
        case 'auth/missing-android-pkg-name':
        print('auth/missing-android-pkg-name');
        break;
        case 'auth/missing-continue-uri':
        print('リクエストには、継続するURLが必要です');
        break;
        case 'auth/missing-ios-bundle-id':
        print('iOS Bundle IDを提供する必要があります');
        break;
        case 'auth/invalid-continue-uri':
        print('リクエストで指定された継続URLが無効です。');
        break;
        case 'auth/unauthorized-continue-uri':
        print('Firebaseコンソールでドメインをホワイトリストに登録してください');
        break;
        case 'auth/user-not-found':
        print('メールアドレスに対応するユーザーがいないです');
        break;
      } 
    } 
  }
}