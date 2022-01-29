// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/rounded_button.dart';
// domain
import 'package:whisper/domain/whisper_link/whisper_link.dart';
import 'package:whisper/links/links_model.dart';

class LinksPage extends ConsumerWidget {

  const LinksPage({
    Key? key,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LinksModel linksModel = ref.watch(linksProvider);
    final Size size = MediaQuery.of(context).size;
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
                itemCount: linksModel.whisperLinks.length,
                itemBuilder: (BuildContext context, int i) {
                  final WhisperLink whisperLink = linksModel.whisperLinks[i];
                  final TextEditingController textEditingController = linksModel.controllers[i];
                  return TextFormField(
                    decoration: InputDecoration(
                      hintText: whisperLink.label,
                      suffixIcon: Icon(Icons.delete)
                    ),
                    onChanged: (text) {
                      linksModel.whisperLinks[i].label = text;
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