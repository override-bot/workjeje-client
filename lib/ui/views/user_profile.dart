import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/clientmodel.dart';
import 'package:workjeje/core/services/authentication.dart';
import 'package:workjeje/core/services/queries.dart';
import 'package:workjeje/ui/views/intro_view.dart';
import 'package:workjeje/utils/router.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/viewmodels/client_view_model.dart';

class UserProfile extends StatefulWidget {
  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  Auth auth = Auth();
  RouteController routeController = RouteController();
  @override
  Widget build(BuildContext context) {
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

    changeMode(bool value) {
      isDark = value;
      themeStatus.darkTheme = value;
      themeProvider.themePreference.setDarkTheme(isDark);
    }

    return FutureBuilder<Client>(
      future: clientViewModel.getProviderById(user!.uid),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
              child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.info,
                      color: textPaint,
                    ))
              ],
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
                                      fontSize: (24 / 720) *
                                          MediaQuery.of(context).size.height,
                                      fontWeight: FontWeight.w500,
                                      color: textPaint),
                                )),
                            subtitle: Text(
                              snapshot.data!.phoneNumber!,
                              style: TextStyle(
                                  fontSize: (18 / 720) *
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
                                Icons.email_outlined,
                                color: textPaint,
                              ),
                              title: Text(
                                snapshot.data!.email!,
                                style: TextStyle(
                                    fontSize: (18 / 720) *
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
                                    fontSize: (18 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w500,
                                    color: textPaint),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 25, top: 5),
                            child: ListTile(
                              leading: Icon(
                                Icons.info_outline,
                                color: textPaint,
                              ),
                              title: Text(
                                "About us",
                                style: TextStyle(
                                    fontSize: (18 / 720) *
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
                              leading: Icon(
                                Icons.report,
                                color: textPaint,
                              ),
                              title: Text(
                                "Report an issue",
                                style: TextStyle(
                                    fontSize: (18 / 720) *
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
                              leading: Icon(
                                Icons.star,
                                color: textPaint,
                              ),
                              title: Text(
                                "Rate us",
                                style: TextStyle(
                                    fontSize: (18 / 720) *
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
                                    fontSize: (18 / 720) *
                                        MediaQuery.of(context).size.height,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              )),
                          Container(
                            margin: EdgeInsets.only(left: 25, top: 5),
                            child: ListTile(
                              onTap: () {
                                auth.signOut();
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
                                    fontSize: (18 / 720) *
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
                                auth.deleteAccount();
                                clientViewModel.deleteClientDetails(user!.uid);
                                routeController.pushAndRemoveUntil(
                                    context, IntroScreen());
                              },
                              leading: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              title: Text(
                                "Delete account",
                                style: TextStyle(
                                    fontSize: (18 / 720) *
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
