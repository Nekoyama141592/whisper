// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class RedirectToUrlButton extends StatelessWidget {

  const RedirectToUrlButton({
    Key? key,
    required this.currentSongDoc,
  }) : super(key: key);

  final DocumentSnapshot currentSongDoc;
  @override 

  Widget build(BuildContext context) {
    
  
    return 
    InkWell(
        onTap: () async {
        if ( await canLaunch(currentSongDoc['link'])) {
          await launch(currentSongDoc['link']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('このURLは無効です')));
        }
      },
      child: Icon(Icons.link),
    );
     
  }
}