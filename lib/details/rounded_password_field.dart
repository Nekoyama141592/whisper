// material
import 'package:flutter/material.dart';
// packages
import 'package:clipboard/clipboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/auth/components/rounded_password_field/rounded_password_field_model.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/text_field_container.dart';

class RoundedPasswordField extends ConsumerWidget {
  
  const RoundedPasswordField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    required this.paste
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> paste;

  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(roundedPasswordFieldProvider);
    return TextFieldContainer(
      child: InkWell(
        onLongPress: () {
          FlutterClipboard.paste()
          .then( paste );
        },
        child: TextField(
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: model.isObscure,
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
              onPressed: (){model.toggleIsObscure();}, 
              icon: model.isObscure ?
              Icon(Icons.visibility)
              : Icon(Icons.visibility_off)
            ),
            border: InputBorder.none
          ),
        ),
      ),
    );
  }
}