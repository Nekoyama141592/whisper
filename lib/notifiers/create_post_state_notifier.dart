// marerial
import 'package:flutter/material.dart';

class CreatePostStateNotifier extends ValueNotifier<CreatePostState> {
  CreatePostStateNotifier() : super(_initialValue);
  static const _initialValue = CreatePostState.initialValue;
}

enum CreatePostState {
  initialValue,
  recording,
  recorded,
  uploading,
  uploaded
}