// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';

class LinksPage extends StatelessWidget {

  const LinksPage({
    Key? key,
    required this.whisperLinksNotifier,
  }) : super(key: key);

  final ValueNotifier<List<WhisperLink>> whisperLinksNotifier;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          voids.onAddLinkButtonPressed(whisperLinksNotifier: whisperLinksNotifier);
        },
        child: Icon(Icons.new_label),
      ),
      body: ValueListenableBuilder<List<WhisperLink>>(
        valueListenable: whisperLinksNotifier,
        builder: (_,whisperLinks,__) {
          return Padding(
            padding: EdgeInsets.all(defaultPadding(context: context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RoundedButton(
                  text: '決定', 
                  widthRate: 0.3, 
                  verticalPadding: defaultPadding(context: context),
                  horizontalPadding: defaultPadding(context: context),
                  press: () { Navigator.pop(context); },
                  textColor: Colors.white, 
                  buttonColor: Theme.of(context).highlightColor
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: whisperLinks.length,
                    itemBuilder: (BuildContext context, int i) {
                      final whisperLink = whisperLinks[i];
                      final TextEditingController labelEditingController = TextEditingController(text: whisperLink.label );
                      final TextEditingController linkEditingController = TextEditingController(text: whisperLink.link);
                      return Padding(
                        padding: EdgeInsets.all(defaultPadding(context: context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ラベル'),
                            TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  child: Icon(Icons.delete),
                                  onTap: () {
                                    voids.onDeleteLinkButtonPressed(whisperLinksNotifier: whisperLinksNotifier, i: i);
                                  },
                                ),
                                hintText: '例)公式サイト'
                              ),
                              controller: labelEditingController,
                              onChanged: (text) {
                                whisperLink.label = text;
                              },
                            ),
                            Text('URL'),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'https://'
                              ),
                              controller: linkEditingController,
                              onChanged: (text) {
                                whisperLink.link = text;
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}