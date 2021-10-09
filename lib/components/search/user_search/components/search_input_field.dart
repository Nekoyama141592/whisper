// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/text_field_container.dart';
// model
import 'package:whisper/components/search/user_search/user_search_model.dart';

class SearchInputField extends StatelessWidget {

  SearchInputField({
    Key? key,
    required this.searchModel,
    required this.controller,
    required this.press
  }) : super(key: key);
  
  final UserSearchModel searchModel;
  final void Function()? press;
  final TextEditingController controller;
  
  @override 
  
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child:TextField(
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
        keyboardType: TextInputType.text,
        onChanged: (text){
          searchModel.searchTerm = text;
        },
        controller: controller,
        cursorColor: kTertiaryColor,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          suffixIcon: TextButton(
            onPressed: press, 
            child: Text(
              '検索',
              style: TextStyle(
                color: kTertiaryColor,
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            )
          ),
          hintText: 'Search...',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.5)
          ),
          border: InputBorder.none
        ),
      ), 
    );
  }
}