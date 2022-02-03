// material
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  
  const EditButton({
    Key? key,
    required this.toEditingMode,
  }) : super(key: key);
  
  final void Function()? toEditingMode;
  @override 
  
  Widget build(BuildContext context) {
    
    return InkWell(
      child: Icon(Icons.edit),
      onTap: toEditingMode,
    );
     
  }
}