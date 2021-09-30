// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/text_field_container.dart';
// model
import 'package:whisper/components/search/post_search/post_search_model.dart';

class SearchInputField extends StatelessWidget {

  const SearchInputField({
    required this.searchModel,
    required this.controller,
    required this.press
  });
  
  final PostSearchModel searchModel;
  final TextEditingController controller;
  final void Function()? press;

  @override 
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
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
        cursorColor: Theme.of(context).highlightColor,
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
            color: Colors.black
          ),
          border: InputBorder.none
        ),
      ), 
    );
  }
}