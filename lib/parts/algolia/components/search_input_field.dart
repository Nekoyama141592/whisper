// import 'package:flutter/material.dart';
// import 'package:whisper/constants/colors.dart';

// import 'package:whisper/parts/text_field_container.dart';
// import 'package:whisper/parts/algolia/search_model.dart';
// class SearchInputField extends StatelessWidget {

//   SearchInputField(this.searchProvider,this.controller,this.press);
  
//   final SearchModel searchProvider;
//   final void Function()? press;
//   final TextEditingController controller;
//   @override 
//   Widget build(BuildContext context) {
//     return TextFieldContainer(
//       TextField(
//         style: TextStyle(
//           color: Colors.black,
//           fontSize: 20,
//           fontWeight: FontWeight.bold
//         ),
//         keyboardType: TextInputType.text,
//         onChanged: (text){
//           searchProvider.searchTerm = text;
//         },
//         controller: controller,
//         cursorColor: kTertiaryColor,
//         decoration: InputDecoration(
//           prefixIcon: Icon(
//             Icons.search,
//             color: Colors.black,
//           ),
//           suffixIcon: TextButton(
//             onPressed: press, 
//             child: Text(
//               '検索',
//               style: TextStyle(
//                 color: kTertiaryColor,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold
//               ),
//             )
//           ),
//           hintText: 'Search...',
//           hintStyle: TextStyle(
//             color: Colors.black
//           ),
//           border: InputBorder.none
//         ),
//       ), 
//       kTertiaryColor
//     );
//   }
// }