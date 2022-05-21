// ignore_for_file: use_key_in_widget_constructors, use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:workjeje/core/services/authentication.dart';
import 'package:workjeje/ui/views/client_index.dart';
import 'package:workjeje/ui/views/signin_view.dart';
import 'package:workjeje/utils/router.dart';

import '../../core/double_mode_implementation/theme_provider.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  Auth auth = Auth();
  RouteController routeController = RouteController();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? const Color(0xffb14181c) : Colors.white;
    Color textPaint = isDark == false ? const Color(0xffb14181c) : Colors.white;
    String link = "assets/wj_final.png";
    Color? background =
        isDark == false ? Color.fromARGB(255, 237, 241, 241) : Colors.black26;

    return SafeArea(
        child: Scaffold(
            body: Container(
      color: background,
      height: double.infinity,
      child: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.only(top: 0, bottom: 0),
        height: MediaQuery.of(context).size.height / 1.1,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(
                "WORKJEJE",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: (28 / 720) * MediaQuery.of(context).size.height,
                    fontWeight: FontWeight.bold,
                    color: textPaint),
              ),
            ),
            Expanded(child: Container()),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.2,
                margin: const EdgeInsets.all(18),
                // child: Image.asset(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain, image: AssetImage(link)))),
            Expanded(child: Container()),
            Container(
              margin: EdgeInsets.only(bottom: 4),
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0), color: textPaint),
              child: MaterialButton(
                  onPressed: () {
                    bool authState = auth.authState();
                    authState == false
                        ? routeController.pushAndRemoveUntil(
                            context, ClientSignInPage())
                        : routeController.pushAndRemoveUntil(
                            context, ClientIndex());
                  },
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                        fontSize:
                            (15 / 720) * MediaQuery.of(context).size.height,
                        fontWeight: FontWeight.w600,
                        color: paint),
                  )),
            ),
            /*   */
          ],
        ),
      )),
    )));
  }
}
