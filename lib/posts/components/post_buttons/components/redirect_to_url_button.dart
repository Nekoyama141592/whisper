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
        voids.showLinkCupertinoModalPopup(context: context, whisperLinks: whisperLinks);
      },
      child: Icon(Icons.link),
    );
     
  }
}