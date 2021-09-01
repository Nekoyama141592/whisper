import 'package:flutter/material.dart';
import 'package:whisper/users/user_show/user_show_model.dart';

class CurrentSongTitle extends StatelessWidget {
  
  CurrentSongTitle(this.userShowProvider);
  final UserShowModel userShowProvider;
  @override  
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SingleChildScrollView(child: Text(userShowProvider.currentSongDoc['title'])),
    );
  }
}