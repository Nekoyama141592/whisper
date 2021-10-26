// material
import 'package:flutter/material.dart';
// packages
import 'package:marquee/marquee.dart';
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
      child: Expanded(
        child: SingleChildScrollView(
          child: Icon(Icons.link),
        ),
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