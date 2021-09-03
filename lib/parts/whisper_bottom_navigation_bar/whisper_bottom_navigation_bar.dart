import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/parts/whisper_bottom_navigation_bar/constants/bottom_navigation_bar_elements.dart';
import 'whisper_bottom_navigation_bar_model.dart';

class WhisperBottomNavigationbar extends ConsumerWidget {
  
  WhisperBottomNavigationbar(this.provider);
  final WhisperBottomNavigationbarModel provider;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: buttonNavigationBarElements,
      currentIndex: provider.currentIndex,
      onTap: (index) {
        provider.onTabTapped(index);
      },
    );
  }
}