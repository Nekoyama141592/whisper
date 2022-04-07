// material
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/rounded_input_field.dart';
import 'package:whisper/details/rounded_button.dart';
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
    final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: defaultHeaderTextSize(context: context) );
    
    return Scaffold(
      appBar: AppBar(
        title: Text('update email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedInputField(
              hintText: '新しいメールアドレス', 
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
              text: 'メールアドレスを認証', 
              widthRate: 0.95, 
              fontSize: defaultHeaderTextSize(context: context),
              press: () async => await updateEmailModel.verifyBeforeUpdateEmail(context: context ),
              textColor: Colors.white, 
              buttonColor: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(height: defaultPadding(context: context),),
            Padding(
              padding: EdgeInsets.all( defaultPadding(context: context) ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '送信された確認メールのリンクをタップしても変更が反映されない場合は',
                      style: textStyle,
                    ),
                    TextSpan(
                      text: 'ログアウト',
                      style: TextStyle(color: Theme.of(context).highlightColor, fontWeight: FontWeight.bold, fontSize: defaultPadding(context: context) ),
                      recognizer: TapGestureRecognizer()..onTap = () => updateEmailModel.showSignOutDialog(context: context)
                    ),
                    TextSpan(
                      text: 'してください',
                      style: textStyle,
                    )
                  ]
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}