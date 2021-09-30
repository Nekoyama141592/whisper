import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  
  RoundedInputField(
    this.hintText,
    this.icon,
    this.controller,
    this.onChanged,
  );

  @override  
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        // これも要素
        keyboardType: TextInputType.emailAddress,
        onChanged: onChanged,
        controller: controller,
        cursorColor: kPrimaryColor.withOpacity(0.7),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
          border: InputBorder.none
        ),
      ),
    );
  }
  
}