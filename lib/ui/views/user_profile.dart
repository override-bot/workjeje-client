// ignore_for_file: use_key_in_widget_constructors, unused_local_variable, prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workjeje/core/models/clientmodel.dart';
import 'package:workjeje/core/services/authentication.dart';

import 'package:workjeje/ui/views/intro_view.dart';
import 'package:workjeje/utils/router.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/viewmodels/client_view_model.dart';

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Auth _auth = Auth();
  final User? user = auth.currentUser;
  RouteController routeController = RouteController();

  final Uri goToAbout = Uri.parse("https://www.workjeje.com");
  Color blue = Color.fromARGB(255, 14, 140, 172);
  @override
  Widget build(BuildContext context) {
    final InAppReview inAppReview = InAppReview.instance;

    final themeStatus = Provider.of<ThemeProvider>(context);
    ThemeProvider themeProvider = ThemeProvider();
    final clientViewModel = Provider.of<ClientViewModel>(context);

    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    IconData darkIcon = isDark == true ? Icons.dark_mode : Icons.light_mode;
    Color? background = isDark == false
        ? Color.fromARGB(255, 237, 241, 241)
        : Color.fromARGB(160, 0, 0, 0);

    return FutureBuilder<Client>(
      future: clientViewModel.getProviderById(user?.uid),
      builder: (BuildContext context, snapshot) {
        print(snapshot.connectionState);
        print(snapshot.data);
        print(user);
        print(snapshot.error);
        if (snapshot.hasData) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
            ),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              color: background,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        color: Colors.white,
                        child: Column(children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.blue,
                              backgroundImage:
                                  NetworkImage(snapshot.data!.imageurl!),
                            ),
                            title: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  snapshot.data!.username!,
                                  style: TextStyle(
                                      fontSize: (20 / 720) *
                                          MediaQuery.of(context).size.height,
                                      fontWeight: FontWeight.w500,
                                      color: textPaint),
                                )),
                            subtitle: Text(
                              snapshot.data!.phoneNumber!,
                              style: TextStyle(
                                  fontSize: (16 / 720) *
                                      MediaQuery.of(context).size.height,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[600]),
                            ),
                          ),
                          Divider(
                            color: textPaint,
                            indent: 15.0,
                            endIndent: 15.0,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 25),
                            child: ListTile(
                              leading: Icon(
                                Icons.email,
                                color: textPaint,
                              ),
                              title: Text(
                                snapshot.data!.email!,
                                style: TextStyle(
                                    fontSize: (16 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w400,
                                    color: textPaint),
                              ),
                            ),
                          ),
                        ])),
                    Container(
                      height: 15,
                    ),
                    Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 10),
                              child: Text(
                                "Workjeje",
                                style: TextStyle(
                                    fontSize: (16 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w500,
                                    color: blue),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 25, top: 5),
                            child: ListTile(
                              onTap: () {
                                launch("https://workjeje.com/html/about.html");
                              },
                              leading: Icon(
                                Icons.info_outline,
                                color: textPaint,
                              ),
                              title: Text(
                                "About us",
                                style: TextStyle(
                                    fontSize: (16 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w400,
                                    color: textPaint),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 25,
                            ),
                            child: ListTile(
                              onTap: () {
                                launch(
                                    "https://workjeje.com/html/contact.html");
                              },
                              leading: Icon(
                                Icons.report,
                                color: Colors.red,
                              ),
                              title: Text(
                                "Report an issue",
                                style: TextStyle(
                                    fontSize: (16 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w400,
                                    color: textPaint),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              left: 25,
                            ),
                            child: ListTile(
                              onTap: () async {
                                if (await inAppReview.isAvailable()) {
                                  inAppReview.requestReview();
                                } else {
                                  print(inAppReview.openStoreListing());
                                }
                              },
                              leading: Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              title: Text(
                                "Rate us",
                                style: TextStyle(
                                    fontSize: (16 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w400,
                                    color: textPaint),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 40, top: 10),
                              child: Text(
                                "Account",
                                style: TextStyle(
                                    fontSize: (16 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 25, top: 5),
                            child: ListTile(
                              onTap: () {
                                _auth.signOut();
                                routeController.pushAndRemoveUntil(
                                    context, IntroScreen());
                              },
                              leading: Icon(
                                Icons.logout,
                                color: Colors.red,
                              ),
                              title: Text(
                                "Log out",
                                style: TextStyle(
                                    fontSize: (16 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 25),
                            child: ListTile(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: FittedBox(
                                          fit: BoxFit.contain,
                                          //  width: MediaQuery.of(context).size.width / 1.1,
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.dangerous,
                                                color: Colors.red,
                                                size: 35,
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              Text(
                                                "Are you sure you want to delete your account?",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20),
                                              ),
                                              Container(
                                                height: 10,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.1,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        child: MaterialButton(
                                                          onPressed: () {
                                                            RouteController()
                                                                .pop(context);
                                                          },
                                                          child: Text(
                                                            "Back",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.blue,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        height: 60,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: Colors.white,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blue)),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.5,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.red,
                                                        ),
                                                        child: MaterialButton(
                                                          onPressed: () async {
                                                            _auth
                                                                .deleteAccount();
                                                            clientViewModel
                                                                .deleteClientDetails(
                                                                    user!.uid);
                                                            auth.signOut();
                                                            routeController
                                                                .pushAndRemoveUntil(
                                                                    context,
                                                                    IntroScreen());
                                                          },
                                                          child: Text(
                                                            "Delete",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              leading: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              title: Text(
                                "Delete account",
                                style: TextStyle(
                                    fontSize: (16 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
