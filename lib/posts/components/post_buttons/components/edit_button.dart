// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';

class EditButton extends StatelessWidget {
  
  const EditButton({
    Key? key,
    required this.currentSongDoc,
    required this.toEditingMode,
  }) : super(key: key);
  
  final DocumentSnapshot currentSongDoc;
  final void Function()? toEditingMode;
  @override 
  
  Widget build(BuildContext context) {
    
    return InkWell(
      child: Icon(Icons.edit),
      onTap: toEditingMode,
    );
     
  }
}