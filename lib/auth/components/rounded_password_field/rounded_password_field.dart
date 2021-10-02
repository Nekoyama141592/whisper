import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/auth/components/rounded_password_field/rounded_password_field_model.dart';

import 'package:whisper/details/text_field_container.dart';
import 'package:whisper/constants/colors.dart';

class RoundedPasswordField extends ConsumerWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  
  RoundedPasswordField(
    this.hintText,
    this.controller,
    this.onChanged,
  );

  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _provider = watch(roundedPasswordFieldProvider);
    return TextFieldContainer(
      child: TextField(
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        keyboardType: TextInputType.text,
        obscureText: _provider.isObscure,
        onChanged: onChanged,
        cursorColor: kPrimaryColor.withOpacity(0.7),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
          icon: Icon(
            Icons.lock,
            color: Colors.black,
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
    );
  }
}