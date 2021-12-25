// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
// packages
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkButton extends StatelessWidget {

  const LinkButton({
    Key? key,
    required this.link
  }) : super(key: key);

  final String link;

  @override 
  
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(Icons.link),
      onTap: () async {
        if ( await canLaunch(link) ) {
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
                      await Future.delayed(Duration(seconds:1));
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
    );
  }
}