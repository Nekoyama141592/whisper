// material
import 'package:flutter/material.dart';
// package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/rounded_password_field.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/views/auth/reauthentication/details/forget_password_text.dart';
import 'package:whisper/l10n/l10n.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/models/auth/account_model.dart';

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
    final L10n l10n = returnL10n(context: context)!;
    return Scaffold(
      appBar: AppBar(
        title: whiteBoldEllipsisHeaderText(context: context, text: l10n.verifyPage),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(defaultPadding(context: context))
          )
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedPasswordField(
              hintText: l10n.currentPassword, 
              controller: passwordInputController, 
              onChanged: (text) => accountModel.password = text,
              paste: (value) => accountModel.password = value
            ),
          ),
          SizedBox(height: defaultPadding(context: context)),
          Center(
            child: RoundedButton(
              text: l10n.verify, 
              widthRate: 0.95, 
              fontSize: defaultHeaderTextSize(context: context),
              press: () async => await accountModel.reauthenticateWithCredential(context: context,currentUser: currentUser, mainModel: mainModel),
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