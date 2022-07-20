// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';

final whisperBottomNavigationbarProvider = ChangeNotifierProvider(
  (ref) => WhisperBottomNavigationbarModel()
);
class WhisperBottomNavigationbarModel extends ChangeNotifier {
  
  // button Nav Bar
  int currentIndex = 0;
  late PageController pageController;

  WhisperBottomNavigationbarModel() {
    init();
  }

  void init() {
    pageController = PageController(
      initialPage: currentIndex
    );
    notifyListeners();
  }

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void onTabTapped(int i) {
    currentIndex = i;
    pageController.animateToPage(
      i, 
      duration: Duration(milliseconds: 300), 
      curve: Curves.easeIn
    );
    notifyListeners();
  }

  void setPageController() {
    pageController = PageController(
      initialPage: currentIndex,
    );
    notifyListeners();
  }
}