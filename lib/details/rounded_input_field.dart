// material
import 'package:flutter/material.dart';
// components
import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  
  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

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
        cursorColor: Theme.of(context).highlightColor.withOpacity(0.7),
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