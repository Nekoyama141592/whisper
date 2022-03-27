// material
import 'package:flutter/material.dart';
// package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/rounded_password_field.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/auth/reauthentication/details/forget_password_text.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/account_model.dart';
// main.dart
import 'package:whisper/main.dart';

class ReauthenticationPage extends StatelessWidget {

  const ReauthenticationPage({
    Key? key,
    required this.currentUser,
    required this.accountModel,
    required this.mainModel
  }) : super(key: key);

  final User? currentUser;
  final AccountModel accountModel;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context) {

    final passwordInputController = TextEditingController(text: accountModel.password);
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('認証ページ'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15.0)
            )
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: RoundedPasswordField(
                hintText: '現在のパスワード', 
                controller: passwordInputController, 
                onChanged: (text) {
                  accountModel.password = text;
                },
                paste: (value) {
                  accountModel.password = value;
                },
              ),
            ),
            SizedBox(height: 16.0),
            Center(
              child: RoundedButton(
                text: '認証する', 
                widthRate: 0.95, 
                fontSize: defaultHeaderTextSize(context: context),
                press: () async { await accountModel.reauthenticateWithCredential(context: context,currentUser: currentUser, mainModel: mainModel); }, 
                textColor: Colors.white, 
                buttonColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
            ForgetPasswordText()
          ],
        ),
      ),
    );
  }
}