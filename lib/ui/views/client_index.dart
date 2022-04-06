import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/ui/views/categories.dart';
import 'package:workjeje/ui/views/client_job_view.dart';
import 'package:workjeje/ui/views/user_profile.dart';

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
    JobView(),
    Container(),
    Container(),
    UserProfile()
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
    Color? background = isDark == false
        ? Color.fromARGB(255, 237, 241, 241)
        : Color.fromARGB(160, 0, 0, 0);

    changeMode(bool value) {
      isDark = value;
      themeStatus.darkTheme = value;
      themeProvider.themePreference.setDarkTheme(isDark);
    }

    return Scaffold(
        bottomNavigationBar: Theme(
            data: Theme.of(context)
                .copyWith(
                    canvasColor: background,
                    // primaryColor: textPaint,
                    textTheme: Theme.of(context).textTheme)
                .copyWith(primaryColor: textPaint),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              backgroundColor: background,
              selectedItemColor: textPaint,
              unselectedItemColor: Colors.grey,
              //  showSelectedLabels: true,
              unselectedLabelStyle: TextStyle(color: textPaint, fontSize: 10),
              selectedLabelStyle: TextStyle(
                  color: Color.fromARGB(255, 30, 197, 226), fontSize: 10),
              showUnselectedLabels: true,
              showSelectedLabels: true,
              selectedFontSize: 15,
              elevation: 0.0,
              onTap: onTabTapped,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_outlined,
                    size: 25,
                  ),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.work_outline,
                      size: 25,
                    ),
                    label: 'My Jobs'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.pending_actions,
                      size: 25,
                    ),
                    label: 'Contracts'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      size: 25,
                    ),
                    label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                      size: 25,
                    ),
                    label: 'Profile'),
              ],
            )),
        body: children[currentIndex]);
  }

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
