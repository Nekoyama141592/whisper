// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/details/rounded_button.dart';
// model
import 'verify_password_reset_model.dart';
class VerifyPasswordResetPage extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    
    final _verifyPasswordResetModel = ref.watch(verifyPasswordResetProvider);
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
              hintText: 'email', 
              icon: Icons.email, 
              controller: emailInputController, 
              onChanged:  (text) {
                _verifyPasswordResetModel.email = text;
              },
              onCloseButtonPressed: () {
                emailInputController.text = '';
                _verifyPasswordResetModel.email = '';
              },
              paste: (value) {
                _verifyPasswordResetModel.email = value;
              },
            ),
          ),
          SizedBox(height: 25.0,),
          Center(
            child: RoundedButton(
              text: 'リセットメールを受け取る', 
              widthRate: 0.95, 
              fontSize: defaultHeaderTextSize(context: context),
              press: () async {
                await _verifyPasswordResetModel.sendPasswordResetEmail(context);
              }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).highlightColor
            ),
          ),
        ],
      ),
    );
  }
}