import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Color formColor;
  
  RoundedInputField(
    this.hintText,
    this.icon,
    this.controller,
    this.onChanged,
    this.formColor
  );

  @override  
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
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
          border: InputBorder.none
        ),
      ),
    );
  }
  
}