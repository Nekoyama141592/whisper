import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';
class PostShowPage extends StatelessWidget{
  final DocumentSnapshot doc;
  PostShowPage(this.doc);
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        backgroundColor: kBackgroundColor,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10
              ),
              child: IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: (){
                  Navigator.pop(context);
                }, 
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  // image
                  child: Text(doc.id),
                ),
                Center(
                  child: Text(doc['title']),
                )
              ],
            ),
          ],
        ),
      );
      
  }
}