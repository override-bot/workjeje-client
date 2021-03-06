// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors, unused_element, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/ui/views/categories.dart';
import 'package:workjeje/ui/views/client_job_view.dart';
import 'package:workjeje/ui/views/contract_tab.dart';

import 'package:workjeje/ui/views/search_screen.dart';
import 'package:workjeje/ui/views/user_profile.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/authentication.dart';

class ClientIndex extends StatefulWidget {
  const ClientIndex({Key? key}) : super(key: key);

  @override
  _ClientIndexState createState() => _ClientIndexState();
}

class _ClientIndexState extends State<ClientIndex> {
  var authHandler = Auth();

  final User? user = auth.currentUser;
  Auth _auth = Auth();
  int currentIndex = 0;
  List children = [
    const Categories(),
    SearchScreen(),
    ContractTabView(),
    JobView(),
    UserProfile()
  ];
  @override
  void initState() {
    super.initState();
    _auth.checkIfUseri(user!.uid, context, user!.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    ThemeProvider themeProvider = ThemeProvider();
    bool isDark = themeStatus.darkTheme;
    Color textPaint = isDark == false ? Color(0xffb14181c) : Colors.white;
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
                    size: 20,
                  ),
                  label: 'Categories',
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                      size: 20,
                    ),
                    label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.pending_actions,
                      size: 20,
                    ),
                    label: 'Contracts'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.work_outline,
                      size: 20,
                    ),
                    label: 'Job Marketplace'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                      size: 20,
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
