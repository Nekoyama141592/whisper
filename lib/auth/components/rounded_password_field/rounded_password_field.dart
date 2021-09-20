import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/auth/components/rounded_password_field/rounded_password_field_model.dart';

import 'package:whisper/parts/components/text_field_container.dart';
import 'package:whisper/constants/colors.dart';

class RoundedPasswordField extends ConsumerWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Color formColor;
  
  
  RoundedPasswordField(
    this.hintText,
    this.controller,
    this.onChanged,
    this.formColor,
  );

  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _provider = watch(roundedPasswordFieldProvider);
    return TextFieldContainer(
      TextField(
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        obscureText: _provider.isObscure,
        onChanged: onChanged,
        cursorColor: kPrimaryColor.withOpacity(0.7),
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.white,
          ),
          suffixIcon: IconButton(
            color: Colors.black,
            onPressed: (){_provider.toggleIsObscure();}, 
            icon: _provider.isObscure ?
            Icon(Icons.visibility_off)
            : Icon(Icons.visibility)
          ),
          border: InputBorder.none
        ),
      ),
      formColor
    );
  }
}