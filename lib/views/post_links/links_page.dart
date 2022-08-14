// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
import 'package:whisper/l10n/l10n.dart';

class LinksPage extends StatelessWidget {

  const LinksPage({
    Key? key,
    required this.whisperLinksNotifier,
    required this.onRoundedButtonPressed,
    required this.roundedButtonText
  }) : super(key: key);

  final ValueNotifier<List<WhisperLink>> whisperLinksNotifier;
  final void Function()? onRoundedButtonPressed;
  final String roundedButtonText;

  @override
  Widget build(BuildContext context) {
    final L10n l10n = returnL10n(context: context)!;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>voids.onAddLinkButtonPressed(whisperLinksNotifier: whisperLinksNotifier),
        child: Icon(Icons.new_label),
      ),
      body: ValueListenableBuilder<List<WhisperLink>>(
        valueListenable: whisperLinksNotifier,
        builder: (_,whisperLinks,__) {
          return Padding(
            padding: EdgeInsets.all(defaultPadding(context: context))/2.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(defaultPadding(context: context)),
                  child: RoundedButton(
                    text: roundedButtonText, 
                    widthRate: 0.3,
                    fontSize: defaultHeaderTextSize(context: context),
                    press: onRoundedButtonPressed,
                    textColor: Colors.white, 
                    buttonColor: Theme.of(context).highlightColor
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: whisperLinks.length,
                    itemBuilder: (BuildContext context, int i) {
                      final whisperLink = whisperLinks[i];
                      final TextEditingController labelEditingController = TextEditingController(text: whisperLink.label );
                      final TextEditingController linkEditingController = TextEditingController(text: whisperLink.url);
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: defaultPadding(context: context)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.label),
                            TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  child: Icon(Icons.delete),
                                  onTap: () {
                                    voids.onDeleteLinkButtonPressed(whisperLinksNotifier: whisperLinksNotifier, i: i);
                                  },
                                ),
                                hintText: l10n.linkExample
                              ),
                              controller: labelEditingController,
                              onChanged: (text) => whisperLink.label = text
                            ),
                            Text(urlText),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: httpsText
                              ),
                              controller: linkEditingController,
                              onChanged: (text) => whisperLink.url = text
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