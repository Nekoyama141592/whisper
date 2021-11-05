// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

class RedirectToUrlButton extends StatelessWidget {

  const RedirectToUrlButton({
    Key? key,
    required this.currentSongMap,
  }) : super(key: key);

  final Map<String,dynamic> currentSongMap;
  @override 

  Widget build(BuildContext context) {
    
    final link = currentSongMap['link'];

    return InkWell(
        onTap: () async {
        if ( await canLaunch(link)) {
          showCupertinoDialog(
            context: context, 
            builder: (_) {
              return CupertinoAlertDialog(
                title: Text('ページ遷移'),
                content: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: link,
                        style: TextStyle(
                          color: Theme.of(context).highlightColor,
                          fontWeight: FontWeight.bold
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          FlutterClipboard.copy(link).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('リンクをコピーしました')));
                          });
                        },
                      ),
                      TextSpan(
                        text: 'に移動します。',
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ]
                  )
                ),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text('Ok'),
                    isDestructiveAction: true,
                    onPressed: () async {
                      Navigator.pop(context);
                      await launch(link);
                    },
                  )
                ],
              );
            }
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('このURLは無効です')));
        }
      },
      child: Icon(Icons.link),
    );
     
  }
}