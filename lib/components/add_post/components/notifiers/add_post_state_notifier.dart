import 'package:flutter/material.dart';

class AddPostStateNotifier extends ValueNotifier<AddPostState> {
  AddPostStateNotifier() : super(_initialValue);
  static const _initialValue = AddPostState.initialValue;
}

enum AddPostState {
  initialValue,
  recording,
  recorded,
  uploading,
  uploaded
}