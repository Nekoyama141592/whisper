import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/auth/components/rounded_password_field/rounded_password_field.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/auth/account/account_model.dart';
import 'package:whisper/constants/colors.dart';

class ReauthenticationPage extends StatelessWidget {

  const ReauthenticationPage({
    Key? key,
    required this.currentUser,
    required this.accountModel
  }) : super(key: key);

  final User? currentUser;
  final AccountModel accountModel;
  @override 
  Widget build(BuildContext context) {

    final passwordInputController = TextEditingController(text: accountModel.password);
    return Scaffold(
      appBar: AppBar(
        title: Text('認証ページ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedPasswordField(
              '現在のパスワード', 
              passwordInputController, 
              (text) {
                accountModel.password = text;
              }, 
            ),
          ),
          Center(
            child: RoundedButton(
              '認証する', 
              0.95, 
              20, 
              10, 
              () async {
                await accountModel.reauthenticateWithCredential(context,currentUser);
              }, 
              Colors.white, 
              kQuaternaryColor
            ),
          )
        ],
      ),
    );
  }
}