// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class RedirectToUrlButton extends StatelessWidget {

  const RedirectToUrlButton({
    Key? key,
    required this.currentSongDocNotifier,
  }) : super(key: key);

  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;

  @override 

  Widget build(BuildContext context) {
    
    return ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier,
      builder: (_,currentSongDoc,__) {
        return currentSongDoc!['link'].isEmpty ?
        SizedBox.shrink()
        : InkWell(
            onTap: () async {
            if ( await canLaunch(currentSongDoc['link'])) {
              await launch(currentSongDoc['link']);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('このURLは無効です')));
            }
          },
          child: Row(
            children: [
              Icon(Icons.link),
              SizedBox(width: 5.0),
              Text(currentSongDoc['link'],style: TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)
            ],
          ),
        );
      }
    );
  }
}