import 'package:flutter/material.dart';

class DisplaySearchResult extends StatelessWidget {

  final String artDes;
  final String artistName;
  final String genre;

  DisplaySearchResult(this.artistName, this.artDes, this.genre);
  @override  
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(artDes, style: TextStyle(fontWeight: FontWeight.bold),),
        Text(artistName, style: TextStyle(fontWeight: FontWeight.bold),),
        Text(genre, style: TextStyle(fontWeight: FontWeight.bold),),
        Divider(color: Colors.black,),
        SizedBox(height: 20,)
      ],
    );
  }
}
