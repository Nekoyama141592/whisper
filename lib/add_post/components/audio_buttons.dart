import 'package:flutter/material.dart';
import 'package:whisper/add_post/add_post_model.dart';

import 'package:whisper/add_post/components/audio_buttons/retry_button.dart';
import 'package:whisper/add_post/components/audio_buttons/record_button.dart';
import 'package:whisper/add_post/components/audio_buttons/upload_button.dart';
class AudioButtons extends StatelessWidget {
  const AudioButtons({
    Key? key,
    required AddPostModel addPostProvider,
  }) : _addPostProvider = addPostProvider, super(key: key);

  final AddPostModel _addPostProvider;

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RetryButton(_addPostProvider),

            RecordButton(_addPostProvider),
            
            UploadButton(_addPostProvider)
            
          ],
        ),
        
      ],
    );
  }
}

