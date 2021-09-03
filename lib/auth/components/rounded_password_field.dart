import 'package:flutter/material.dart';
import 'package:whisper/auth/components/text_field_container.dart';
import 'package:whisper/constants/colors.dart';

class RoundedPasswordField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  RoundedPasswordField(
    this.hintText,
    this.controller,
    this.onChanged
  );

  @override  
  Widget build(BuildContext context) {
    return TextFieldContainer(
      TextField(
        style: TextStyle(fontSize: 20),
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor.withOpacity(0.7),
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Colors.white,
          ),
          suffixIcon: Icon(
            Icons.visibility_off
          ),
          border: InputBorder.none
        ),
      )
    );
  }
}