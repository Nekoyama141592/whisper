// material
import 'package:flutter/material.dart';
// package
import 'package:url_launcher/url_launcher.dart';

class RedirectToUrlButton extends StatelessWidget {

  const RedirectToUrlButton({
    Key? key,
    required this.currentSongMap,
  }) : super(key: key);

  final Map<String,dynamic> currentSongMap;

  @override 

  Widget build(BuildContext context) {
    
    
    return  
    InkWell(
      onTap: () async {
        if ( await canLaunch(currentSongMap['link'])) {
          await launch(currentSongMap['link']);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('このURLは無効です')));
        }
      },
      child: Row(
        children: [
          Icon(Icons.link),
          SizedBox(width: 5.0),
          Text(currentSongMap['link'],style: TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
    
  }
}