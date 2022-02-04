// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;

class RedirectToUrlButton extends StatelessWidget {

  const RedirectToUrlButton({
    Key? key,
    required this.whisperPost
  }) : super(key: key);

  final Post whisperPost;
  @override 

  Widget build(BuildContext context) {

    final List<WhisperLink> whisperLinks = whisperPost.links.map((element) => fromMapToWhisperLink(whisperLink: element) ).toList();

    return InkWell(
      onTap: () async {
        showCupertinoModalPopup(
          context: context, 
          builder: (innerContext) {
            return CupertinoActionSheet(
              actions: whisperLinks.map((whisperLink) => CupertinoActionSheetAction(
                child: Text(whisperLink.label,style: textStyle(context: context),),
                onPressed: () {
                  voids.showLinkDialogue(context: context, link: whisperLink.link );
                }, 
              ) ).toList(),
            );
          }
        );  
      },
      child: Icon(Icons.link),
    );
     
  }
}