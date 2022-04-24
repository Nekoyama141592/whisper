// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'verify_password_reset_model.dart';

class VerifyPasswordResetPage extends ConsumerWidget {
  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    
    final L10n l10n = returnL10n(context: context)!;
    final verifyPasswordResetModel = ref.watch(verifyPasswordResetProvider);
    final emailInputController = TextEditingController(text: verifyPasswordResetModel.email);
    return Scaffold(
      appBar: AppBar(
        title: whiteBoldHeaderText(context: context, text: l10n.verifyResetPassword)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedInputField(
              hintText: l10n.email, 
              icon: Icons.email, 
              controller: emailInputController, 
              onChanged:  (text) => verifyPasswordResetModel.email = text,
              onCloseButtonPressed: () {
                emailInputController.text = '';
                verifyPasswordResetModel.email = '';
              },
              paste: (value) => verifyPasswordResetModel.email = value,
            ),
          ),
          SizedBox(height: defaultPadding(context: context),),
          Center(
            child: RoundedButton(
              text: l10n.receiveResetEmail, 
              widthRate: 0.95, 
              fontSize: defaultHeaderTextSize(context: context),
              press: () async => await verifyPasswordResetModel.sendPasswordResetEmail(context: context),
              textColor: Colors.white, 
              buttonColor: Theme.of(context).highlightColor
            ),
          ),
        ],
      ),
    );
  }
}