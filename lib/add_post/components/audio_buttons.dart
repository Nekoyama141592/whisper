import 'package:flutter/material.dart';
import 'package:whisper/add_post/add_post_model.dart';

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
            AudioButton(
              'リトライ',
              Icon(Icons.replay),
              (){_addPostProvider.onRecordAgainButtonPressed();}
            ),

            AudioButton(
              _addPostProvider.isRecording ?
              '停止する'
              : '録音する',
              _addPostProvider.isRecording ?
              Icon(Icons.pause)
              : Icon(Icons.fiber_manual_record),
              () async {
                _addPostProvider.onRecordButtonPressed(context);
              }
            ),
            
            AudioButton(
              '公開する',
              Icon(Icons.upload_file),
              () async {
                await _addPostProvider.onAddButtonPressed(context);
              }
            ),
            
          ],
        ),
        // _addPostProvider.isRecorded ?
        // !_addPostProvider.isPlaying ?
        // AudioButton(
        //   '再生する', 
        //   Icon(Icons.play_arrow), 
        //   () {
        //     _addPostProvider.play();
        //   }
        // )
        // : AudioButton(
        //   '停止する', 
        //   Icon(Icons.pause), 
        //   () {
        //     _addPostProvider.pause();
        //   }
        // )
        // : SizedBox()
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LinearProgressIndicator(),
        )
      ],
    );
  }
}

class AudioButton extends StatelessWidget {

  AudioButton(this.description,this.icon,this.press);
  final String description;
  final Widget icon;
  final void Function()? press;
  @override 
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          iconSize: 100,
          tooltip: description,
          icon: icon,
          onPressed: press, 
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10
          ),
          child: Text(
            description,
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }
}