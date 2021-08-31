import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'add_post_model.dart';

class AddPostPage extends ConsumerWidget {
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _addPostProvider = watch(addPostProvider);
    final postTitleController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('add'),
      ),
      body: Center(
        child: Column(
          children: [
            _addPostProvider.isUploading ?
            Indicator()
            : AudioButtons(addPostProvider: _addPostProvider),
            TextField(
              controller: postTitleController,
              onChanged: (text) {
                _addPostProvider.postTitle = text;
              },
            )
          ],
        ),
      ),
    );
  }
}

class AudioButtons extends StatelessWidget {
  const AudioButtons({
    Key? key,
    required AddPostModel addPostProvider,
  }) : _addPostProvider = addPostProvider, super(key: key);

  final AddPostModel _addPostProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.replay),
          onPressed: () {
            _addPostProvider.onRecordAgainButtonPressed();
          }, 
        ),
        IconButton(
          icon: _addPostProvider.isRecording ?
          Icon(Icons.pause)
          : Icon(Icons.fiber_manual_record),
          onPressed: () async {
            _addPostProvider.onRecordButtonPressed(context);
          }, 
        ),
        IconButton(
          icon: Icon(Icons.upload_file),
          onPressed: () async {
            await _addPostProvider.onAddButtonPressed(context);
            Navigator.pop(context);
          }, 
        )
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