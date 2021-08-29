import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addPostProvider = ChangeNotifierProvider(
  (ref) => AddPostModel()
);

class AddPostModel extends ChangeNotifier {
  
}