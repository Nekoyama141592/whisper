// material
import 'package:flutter/material.dart';
// packages
import 'package:clipboard/clipboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/models/auth/rounded_password_field_model.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/doubles.dart';
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
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(roundedPasswordFieldProvider);
    return TextFieldContainer(
      child: InkWell(
        onLongPress: () async => await FlutterClipboard.paste().then( paste ),
        child: TextField(
          style: TextStyle(
            color: Colors.black,
            fontSize: defaultHeaderTextSize(context: context),
            fontWeight: FontWeight.bold
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: model.isObscure,
          onChanged: onChanged,
          cursorColor: kPrimaryColor.withOpacity(0.7),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2 ),
            icon: Icon(
              Icons.lock,
              color: Colors.black,
            ),
            suffixIcon: InkWell(
              onTap: () => model.toggleIsObscure(),
              child: Icon(model.isObscure ? Icons.visibility_off : Icons.visibility,color: Colors.black, )
            ),
            border: InputBorder.none
          ),
        ),
      ),
    );
  }
}