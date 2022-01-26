// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// domain
import 'package:whisper/domain/whisper_link/whisper_link.dart';
import 'package:whisper/links/links_model.dart';

class LinksPage extends ConsumerWidget {

  const LinksPage({
    Key? key,
  }) : super(key: key);

  
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final LinksModel linksModel = watch(linksProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                print(linksModel.whisperLinks[i].label);
              },
              
              controller: textEditingController,
            );
          }
        ),
      ),
    );
  }
}