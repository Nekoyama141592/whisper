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
// main.dart
import 'package:whisper/main.dart';

class VerifyPasswordResetPage extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    
    final verifyPasswordResetModel = ref.watch(verifyPasswordResetProvider);
    final emailInputController = TextEditingController(text: verifyPasswordResetModel.email);
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
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
                  verifyPasswordResetModel.email = text;
                },
                onCloseButtonPressed: () {
                  emailInputController.text = '';
                  verifyPasswordResetModel.email = '';
                },
                paste: (value) {
                  verifyPasswordResetModel.email = value;
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
                  await verifyPasswordResetModel.sendPasswordResetEmail(context);
                }, 
                textColor: Colors.white, 
                buttonColor: Theme.of(context).highlightColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}