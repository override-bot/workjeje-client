import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/ui/views/categories.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/authentication.dart';

class ClientIndex extends StatefulWidget {
  @override
  _ClientIndexState createState() => _ClientIndexState();
}

class _ClientIndexState extends State<ClientIndex> {
  var authHandler = Auth();

  final User? user = auth.currentUser;

  int currentIndex = 0;
  List children = [
    Categories(),
    Container(),
    Container(),
    Container(),
    Container()
  ];
  @override
  void initState() {
    super.initState();
    final User? user = auth.currentUser;
    // updatePosition("clients", user.uid);
  }

  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    ThemeProvider themeProvider = ThemeProvider();
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    IconData darkIcon = Icons.person;
    changeMode(bool value) {
      isDark = value;
      themeStatus.darkTheme = value;
      themeProvider.themePreference.setDarkTheme(isDark);
    }

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: paint,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0.0,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    size: 25,
                    color: currentIndex == 0 ? Colors.blue : textPaint),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.work,
                    size: 25,
                    color: currentIndex == 1 ? Colors.blue : textPaint),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.pending_actions,
                    size: 25,
                    color: currentIndex == 2 ? Colors.blue : textPaint),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.search,
                    size: 25,
                    color: currentIndex == 3 ? Colors.blue : textPaint),
                label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings,
                    size: 25,
                    color: currentIndex == 4 ? Colors.blue : textPaint),
                label: ''),
          ],
        ),
        body: children[currentIndex]);
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
