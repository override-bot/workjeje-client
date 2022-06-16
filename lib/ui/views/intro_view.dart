// ignore_for_file: use_key_in_widget_constructors, use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:workjeje/core/services/authentication.dart';
import 'package:workjeje/ui/views/client_index.dart';
import 'package:workjeje/ui/views/get_started.dart';
import 'package:workjeje/ui/views/signup_view.dart';

import 'package:workjeje/utils/router.dart';

import '../../core/double_mode_implementation/theme_provider.dart';

class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  Auth auth = Auth();
  RouteController routeController = RouteController();
  Color blue = Color.fromARGB(255, 14, 140, 172);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? const Color(0xffb14181c) : Colors.white;
    Color textPaint = isDark == false ? const Color(0xffb14181c) : Colors.white;
    String link = "assets/wj_final.png";
    Color? background =
        isDark == false ? Color.fromARGB(255, 237, 241, 241) : Colors.black26;

    return Scaffold(
      body: Container(
          color: background,
          height: double.infinity,
          child: Container(
            margin: const EdgeInsets.only(top: 0, bottom: 0),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container()),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3.4,
                    margin: const EdgeInsets.only(top: 0),
                    // child: Image.asset(),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain, image: AssetImage(link)))),
                Expanded(child: Container()),
                Container(
                    margin: EdgeInsets.only(top: 0),
                    child: Text("Welcome to Workjeje",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize:
                                25 / 720 * MediaQuery.of(context).size.height,
                            color: Color.fromARGB(255, 14, 140, 172)))),
                Container(
                    margin: EdgeInsets.only(top: 7),
                    child: Text(
                        "Hire professional service providers with better reviews",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize:
                                20 / 720 * MediaQuery.of(context).size.height,
                            color: Colors.grey))),
                Expanded(child: Container()),
                Container(
                  margin: EdgeInsets.all(25),
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0), color: blue),
                  child: MaterialButton(
                      onPressed: () {
                        bool authState = auth.authState();
                        authState == false
                            ? routeController.pushAndRemoveUntil(
                                context, GetStarted())
                            : routeController.pushAndRemoveUntil(
                                context, ClientIndex());
                      },
                      child: Text(
                        auth.authState() == false ? "Get Started" : "Continue",
                        style: TextStyle(
                            fontSize:
                                (13 / 720) * MediaQuery.of(context).size.height,
                            fontWeight: FontWeight.w600,
                            color: paint),
                      )),
                ),
                /*   */
              ],
            ),
          )),
    );
  }
}
