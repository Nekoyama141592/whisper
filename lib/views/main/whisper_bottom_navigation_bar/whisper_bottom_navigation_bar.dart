// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/bottom_navigation_bar_elements.dart';
// model
import '../../../models/main/whisper_bottom_navigation_bar_model.dart';

class WhisperBottomNavigationbar extends StatelessWidget {
  
  const WhisperBottomNavigationbar({
    Key? key,
    required this.model,
  }) : super(key: key);

  final WhisperBottomNavigationbarModel model;

  @override
  Widget build(BuildContext context) {
    
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: buttonNavigationBarElements,
      currentIndex: model.currentIndex,
      onTap: (index) => model.onTabTapped(index)
    );
  }
}