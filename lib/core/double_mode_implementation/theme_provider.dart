import 'package:flutter/material.dart';
import 'package:workjeje/core/double_mode_implementation/pref_store.dart';
//import 'package:provider/provider.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreference themePreference = ThemePreference();
  bool _darkTheme = false;
  bool get darkTheme => _darkTheme;
  set darkTheme(bool value) {
    _darkTheme = value;
    themePreference.setDarkTheme(value);
    notifyListeners();
  }
}
