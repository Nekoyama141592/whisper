// material
import 'package:flutter/material.dart';
// domain
import 'package:whisper/domain/whisper_link/whisper_link.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
class LinkButton extends StatelessWidget {

  const LinkButton({
    Key? key,
    required this.passiveWhisperUser
  }) : super(key: key);

  final WhisperUser passiveWhisperUser;

  @override 
  
  Widget build(BuildContext context) {

    final List<WhisperLink> whisperLinks = passiveWhisperUser.links.map((element) => fromMapToWhisperLink(whisperLink: element) ).toList();

    return InkWell(
      onTap: () => voids.showLinkCupertinoModalPopup(context: context, whisperLinks: whisperLinks),
      child: Icon(Icons.link),
    );
     
  }
}