// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'update_email_model.dart';

class UpdateEmailPage extends ConsumerWidget {

  const UpdateEmailPage({
    Key? key,
    required this.currentUser
  }) : super(key: key);

  final User? currentUser;

  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    
    final updateEmailModel = ref.watch(updateEmailProvider);
    final newEmailInputController = TextEditingController(text: updateEmailModel.newEmail);
    final L10n l10n = returnL10n(context: context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: whiteBoldEllipsisHeaderText(context: context, text: l10n.updateEmail)
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedInputField(
              hintText: l10n.newEmail, 
              icon: Icons.email, 
              controller: newEmailInputController, 
              onChanged:  (text) => updateEmailModel.newEmail = text,
              onCloseButtonPressed: () {
                newEmailInputController.text = '';
                updateEmailModel.newEmail = '';
              },
              paste: (value) => updateEmailModel.newEmail = value
            ),
            SizedBox(height: defaultPadding(context: context),),
            RoundedButton(
              text: l10n.verifyEmail,
              widthRate: 0.95, 
              fontSize: defaultHeaderTextSize(context: context),
              press: () async => await updateEmailModel.verifyBeforeUpdateEmail(context: context ),
              textColor: Colors.white, 
              buttonColor: Theme.of(context).colorScheme.secondary,
            ),
          ],
        ),
      ),
    );
  }
}