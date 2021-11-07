// material
import 'package:flutter/material.dart';
// package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/auth/components/rounded_password_field/rounded_password_field.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/auth/reauthentication/details/forget_password_text.dart';
// model
import 'package:whisper/auth/account/account_model.dart';

class ReauthenticationPage extends StatelessWidget {

  const ReauthenticationPage({
    Key? key,
    required this.currentUser,
    required this.accountModel,
    required this.currentUserDoc
  }) : super(key: key);

  final User? currentUser;
  final AccountModel accountModel;
  final DocumentSnapshot currentUserDoc;

  @override 
  Widget build(BuildContext context) {

    final passwordInputController = TextEditingController(text: accountModel.password);
    return Scaffold(
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
              verticalPadding: 20.0, 
              horizontalPadding: 10.0, 
              press: () async { await accountModel.reauthenticateWithCredential(context,currentUser,currentUserDoc); }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          ForgetPasswordText()
        ],
      ),
    );
  }
}