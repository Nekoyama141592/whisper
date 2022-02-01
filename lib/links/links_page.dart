// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/rounded_button.dart';
// domain
import 'package:whisper/domain/whisper_link/whisper_link.dart';

class LinksPage extends StatelessWidget {

  const LinksPage({
    Key? key,
    required this.controllers,
    required this.whisperLinks
  }) : super(key: key);

  final List<WhisperLink> whisperLinks;
  final List<TextEditingController> controllers;
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RoundedButton(
              text: '決定', 
              widthRate: 0.25, 
              verticalPadding: 10.0, 
              horizontalPadding: 5.0, 
              press: () { Navigator.pop(context); },
              textColor: Colors.white, 
              buttonColor: Theme.of(context).highlightColor
            ),
            Expanded(
              child: ListView.builder(
                itemCount: whisperLinks.length,
                itemBuilder: (BuildContext context, int i) {
                  final WhisperLink whisperLink = whisperLinks[i];
                  final TextEditingController textEditingController = controllers[i];
                  return TextFormField(
                    decoration: InputDecoration(
                      hintText: whisperLink.label,
                      suffixIcon: Icon(Icons.delete)
                    ),
                    onChanged: (text) {
                      whisperLinks[i].label = text;
                    },
                    
                    controller: textEditingController,
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}