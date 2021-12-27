// material
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Widget build(BuildContext context, ScopedReader watch) {
    
    final updateEmailModel = watch(updateEmailProvider);
    final newEmailInputController = TextEditingController(text: updateEmailModel.newEmail);
    final textStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0);
    
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
              onChanged:  (text) {
                updateEmailModel.newEmail = text;
              },
              paste: (value) {
                updateEmailModel.newEmail = value;
              },
            ),
            SizedBox(height: 16,),
            RoundedButton(
              text: 'メールアドレスを認証', 
              widthRate: 0.95, 
              verticalPadding: 20.0,
              horizontalPadding: 10.0,
              press: () async {
                await updateEmailModel.verifyBeforeUpdateEmail(context);        
              }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).colorScheme.secondary,
            ),
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '送信された確認メールのリンクをタップしても変更が反映されない場合は',
                      style: textStyle,
                    ),
                    TextSpan(
                      text: 'ログアウト',
                      style: TextStyle(color: Theme.of(context).highlightColor, fontWeight: FontWeight.bold, fontSize: 25.0 ),
                      recognizer: TapGestureRecognizer()..onTap = () async {
                        updateEmailModel.showSignOutDialog(context);
                      },
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