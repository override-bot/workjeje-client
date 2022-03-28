import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/double_mode_implementation/pref_store.dart';
import 'package:workjeje/core/viewmodels/contract_view_model.dart';
import 'package:workjeje/core/viewmodels/jobs_view_models.dart';
import 'package:workjeje/core/viewmodels/review_view_model.dart';

import 'core/double_mode_implementation/theme_provider.dart';
import 'ui/views/intro_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeProvider = ThemeProvider();
  JobViewModel jobViewModel = JobViewModel();
  ContractViewModel contractViewModel = ContractViewModel();
  ReviewViewModel reviewViewModel = ReviewViewModel();
  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeProvider.darkTheme = await themeProvider.themePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return jobViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return contractViewModel;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return reviewViewModel;
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'workjeje client',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: themeProvider.darkTheme == true
              ? const Color(0xffb14181c)
              : Colors.white,
        ),
        home: IntroScreen(),
      ),
    );
  }
}
