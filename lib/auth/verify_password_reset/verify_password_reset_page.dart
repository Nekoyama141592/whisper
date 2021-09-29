import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/details/rounded_button.dart';

import 'verify_password_reset_model.dart';
class VerifyPasswordResetPage extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    
    final _verifyPasswordResetModel = watch(verifyPasswordResetProvider);
    final emailInputController = TextEditingController(text: _verifyPasswordResetModel.email);
    return Scaffold(
      appBar: AppBar(
        title: Text('verifyPasswordReset'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedInputField(
              'email', 
              Icons.email, 
              emailInputController, 
              (text) {
                _verifyPasswordResetModel.email = text;
              }, 
              kTertiaryColor
            ),
          ),
          Center(
            child: RoundedButton(
              'リセットメールを受け取る', 
              0.95, 
              20, 
              10, 
              () async {
                await _verifyPasswordResetModel.sendPasswordResetEmail(context);
              }, 
              Colors.black, 
              kQuaternaryColor
            ),
          ),
        ],
      ),
    );
  }
}