import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/constants/colors.dart';

import 'package:whisper/details/rounded_input_field.dart';

import 'package:whisper/details/rounded_button.dart';

import 'update_email_model.dart';

class UpdateEmailPage extends ConsumerWidget {

  UpdateEmailPage({
    Key? key,
    required this.currentUser
  }) : super(key: key);

  final User? currentUser;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    
    final _updateEmailModel = watch(updateEmailProvider);
    final newEmailInputController = TextEditingController(text: _updateEmailModel.newEmail);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('update email'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedInputField(
              '新しいメールアドレス', 
              Icons.email, 
              newEmailInputController, 
              (text) {
                _updateEmailModel.newEmail = text;
              }, 
              kPrimaryColor
            ),
            SizedBox(height: 16,),
            RoundedButton(
              'メールアドレスを認証', 
              0.95, 
              20, 
              10, 
              () async {
                await _updateEmailModel.verifyBeforeUpdateEmail(context);        
              }, 
              Colors.white, 
              kSecondaryColor
            ),
            Text('リンクをタップしても変更が反映されない場合は'),
            Text('一度、Whisperのタブを切ってください')
          ],
        ),
      ),
    );
  }
}