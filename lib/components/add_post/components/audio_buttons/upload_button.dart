import 'package:flutter/material.dart';

import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';

import 'package:whisper/components/add_post/add_post_model.dart';

class UploadButton extends StatelessWidget {

  UploadButton(this.addPostProvider);
  final AddPostModel addPostProvider;
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      '公開する',
      Icon(Icons.upload_file),
      () async {
        // addPostProvider.startLoading();
        Navigator.pop(context);
        // addPostProvider.endLoading();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('SnackBar'),
            duration: Duration(seconds: 5),
          )
        );
        // await addPostProvider.onUploadButtonPressed(context);
      }
    );
  }
}