// material
import 'package:flutter/material.dart';
// packages
import 'package:url_launcher/url_launcher.dart';

class LinkButton extends StatelessWidget {

  const LinkButton({
    Key? key,
    required this.link
  }) : super(key: key);

  final String link;

  @override 
  
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.link),
          SizedBox(width: 5.0),
          Text(
            link,
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
      onTap: () async {
        if ( await canLaunch(link) ) {
          await launch(link);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('このURLは無効です')));
        }
    
      },
    );
  }
}