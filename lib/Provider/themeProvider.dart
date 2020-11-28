import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _on = false;

  bool getTheme() => _on;

  setTheme(bool value) {
    _on = value;

    notifyListeners();
  }
}
