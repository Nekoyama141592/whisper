// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/text_field_container.dart';

class SearchInputField extends StatelessWidget {

  SearchInputField({
    Key? key,
    required this.search,
    required this.onChanged,
    required this.onLongPress,
    required this.controller,
  }) : super(key: key);
  
  final void Function()? search;
  final void Function(String)? onChanged;
  final void Function()? onLongPress;
  final TextEditingController controller;
  
  @override 
  
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child:InkWell(
        onLongPress: onLongPress,
        child: TextField(
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
          keyboardType: TextInputType.text,
          onChanged: onChanged,
          controller: controller,
          cursorColor: kTertiaryColor,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.close,color: Colors.black,),
            suffixIcon: TextButton(
              onPressed: search, 
              child: Text('検索',style: TextStyle(color: kTertiaryColor,fontSize: 18,fontWeight: FontWeight.bold),),
            ),
            hintText: 'Search...',
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5)
            ),
            border: InputBorder.none
          ),
        ),
      ), 
    );
  }
}