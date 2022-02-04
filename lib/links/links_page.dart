// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
class LinksPage extends StatelessWidget {

  const LinksPage({
    Key? key,
    required this.whisperLinksOfModel
  }) : super(key: key);

  final List<WhisperLink> whisperLinksOfModel;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                itemCount: whisperLinksOfModel.length,
                itemBuilder: (BuildContext context, int i) {
                  final TextEditingController labelEditingController = TextEditingController(text: whisperLinksOfModel[i].label );
                  final TextEditingController linkEditingController = TextEditingController(text: whisperLinksOfModel[i].link);
                  return Padding(
                    padding: EdgeInsets.all(size.height/64.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.delete)
                          ),
                          controller: labelEditingController,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.delete)
                          ),
                          controller: linkEditingController
                        ),
                      ],
                    ),
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