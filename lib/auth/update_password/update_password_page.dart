// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/auth/components/rounded_password_field/rounded_password_field.dart';
// model
import 'update_password_model.dart';

class UpdatePasswordPage extends ConsumerWidget {

  const UpdatePasswordPage({
    Key? key,
    required this.currentUser
  }) : super(key: key);

  final User? currentUser;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {

    final _updatePasswordModel = watch(updatePasswordProvider);
    final newPasswordInputController = TextEditingController(text: _updatePasswordModel.newPassword);
    final confirmPasswordInputController = TextEditingController(text: _updatePasswordModel.confirmPassword);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('update password'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedPasswordField(
              hintText: '新しいパスワード', 
              controller: newPasswordInputController, 
              onChanged:  (text) {
                _updatePasswordModel.newPassword = text;
              }, 
            ),
          ),
          Center(
            child: RoundedPasswordField(
              hintText: 'パスワード(確認)', 
              controller: confirmPasswordInputController, 
              onChanged:  (text) {
                _updatePasswordModel.confirmPassword = text;
              },
            ),
          ),
          Center(
            child: RoundedButton(
              'パスワードを更新', 
              0.95, 
              20, 
              10, 
              () {
                _updatePasswordModel.onUpdateButtonPressed(context);
              }, 
              Colors.white, 
              kSecondaryColor
            ),
          )
        ],
      ),
    );
  }
}
