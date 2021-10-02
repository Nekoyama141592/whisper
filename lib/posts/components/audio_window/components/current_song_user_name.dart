// material
import 'package:flutter/cupertino.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CurrentSongUserName extends StatelessWidget {
  
  const CurrentSongUserName({
    Key? key,
    required this.currentSongDocNotifier
  }) : super(key: key);

  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  
  @override
  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        return Text(
          currentSongDoc!['userName'], 
          style: TextStyle(
            fontSize: 20
          ),
          overflow: TextOverflow.ellipsis,
        );
      }
    );
  }
}