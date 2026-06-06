import 'package:flutter/material.dart';

class AccessibilityProvider extends ChangeNotifier {
  bool _isAudioAssistEnabled = true;

  bool get isAudioAssistEnabled => _isAudioAssistEnabled;

  void toggleAudioAssist(bool value) {
    _isAudioAssistEnabled = value;
    notifyListeners();
  }
}
