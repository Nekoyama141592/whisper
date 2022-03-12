// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  
  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.onCloseButtonPressed,
    required this.onChanged,
    required this.paste
  }) : super(key: key);

  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final void Function()? onCloseButtonPressed;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> paste;

  @override  
  Widget build(BuildContext context) {

    return TextFieldContainer(
      child: InkWell(
        onLongPress: () async {
          await FlutterClipboard.paste()
          .then( paste );
        },
        child: TextFormField(
          style: TextStyle(
            color: Colors.black,
            fontSize: defaultHeaderTextSize(context: context),
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
            suffixIcon: InkWell(
              child: Icon(Icons.close,color: Colors.black,),
              onTap: onCloseButtonPressed,
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.6),fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2 ),
            border: InputBorder.none
          ),
        ),
      ),
    );
  }
  
}