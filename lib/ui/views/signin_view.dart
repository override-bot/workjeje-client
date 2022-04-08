// ignore: unused_import

// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_full_hex_values_for_flutter_colors, duplicate_ignore

import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/services/authentication.dart';
import 'package:workjeje/ui/shared/popup.dart';
import 'package:workjeje/ui/shared/shared_button.dart';
import 'package:workjeje/ui/views/client_index.dart';
import 'package:workjeje/ui/views/signup_view.dart';
import 'package:workjeje/utils/router.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../shared/custom_textfield.dart';

class ClientSignInPage extends StatefulWidget {
  @override
  _ClientSignInPageState createState() => _ClientSignInPageState();
}

class _ClientSignInPageState extends State<ClientSignInPage> {
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  bool isLoading = false;
  Auth auth = Auth();
  RouteController routeController = RouteController();
  PopUp popUp = PopUp();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    String link = "assets/wj_final.png";
    return Scaffold(
      body: Container(
          color: paint,
          child: ListView(children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                margin: EdgeInsets.all(25.0),
                // child: Image.asset(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain, image: AssetImage(link)))),
            Text("Sign In",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: textPaint))
                .centered(),
            CustomTextField(
              controller: _emailField,
              hintText: "jdoe@gmail.com",
              labelText: "Email",
            ),
            CustomTextField(
              controller: _passwordField,
              obscureText: true,
              labelText: "Password",
              hintText: '********',
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              // ignore: prefer_const_constructors
              Text(
                "Don't have an account?  ",
                style: const TextStyle(fontSize: 17, color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  routeController.push(context, ClientSignUpPage());
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 17,
                      color: textPaint,
                      fontWeight: FontWeight.bold),
                ),
              )
            ]),
            Container(
              height: 20,
            ),
            LoadingButton(
                label: "login",
                isLoading: isLoading,
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  auth
                      .signInClient(_emailField.text, _passwordField.text)
                      .then((value) {
                    routeController.pushAndRemoveUntil(context, ClientIndex());
                  }).catchError((e) {
                    popUp.showError(e.message, context);
                  });
                  setState(() {
                    isLoading = false;
                  });
                }),
          ])),
    );
  }
}
