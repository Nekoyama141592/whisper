// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/components/whisper_bottom_navigation_bar/constants/bottom_navigation_bar_elements.dart';
// model
import 'whisper_bottom_navigation_bar_model.dart';

class WhisperBottomNavigationbar extends ConsumerWidget {
  
  const WhisperBottomNavigationbar({
    Key? key,
    required this.model
  }) : super(key: key);

  final WhisperBottomNavigationbarModel model;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: buttonNavigationBarElements,
      currentIndex: model.currentIndex,
      onTap: (index) {
        model.onTabTapped(index);
      },
    );
  }
}