//import 'dart:html';

// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/job_model.dart';
import 'package:workjeje/core/viewmodels/jobs_view_models.dart';
import 'package:workjeje/ui/views/job_info_view.dart';
import 'package:workjeje/utils/stringManip.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';
import '../../utils/datetime.dart';
import '../../utils/router.dart';

class JobView extends StatefulWidget {
  @override
  JobViewState createState() => JobViewState();
}

class JobViewState extends State<JobView> {
  FirebaseQueries firebaseQueries = FirebaseQueries();
  DateTimeFormatter dateTimeFormatter = DateTimeFormatter();
  RouteController routeController = RouteController();
  StringManip stringManip = StringManip();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    final jobViewModel = Provider.of<JobViewModel>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    Color? background = isDark == false
        ? Color.fromARGB(255, 237, 241, 241)
        : Color.fromARGB(160, 0, 0, 0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0.0,
        title: Text(
          "My Jobs",
          style: TextStyle(
              color: textPaint,
              fontWeight: FontWeight.w500,
              fontSize: (24 / 720) * MediaQuery.of(context).size.height),
        ),
      ),
      body: Container(
        height: double.infinity,
        color: background,
        child: FutureBuilder<List<Jobs>>(
          future: jobViewModel.getClientJobs(user!.uid),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "You have not posted any job",
                    style: TextStyle(
                        color: textPaint,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                      //    color: paint,
                      decoration: BoxDecoration(
                          color: paint,
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                            backgroundColor: textPaint,
                            child: Text(
                              stringManip.getFirstLetter(
                                  snapshot.data![index].username),
                              style: TextStyle(color: paint, fontSize: 28),
                            )),
                        title: Text(
                          snapshot.data![index].username.capitalizeFirstofEach,
                          style: TextStyle(
                              fontSize: (13 / 720) *
                                  MediaQuery.of(context).size.height,
                              fontWeight: FontWeight.w500,
                              color: textPaint),
                        ),
                        subtitle: Text(
                          '${snapshot.data![index].jobCategory} job'
                              .capitalizeFirstofEach,
                          style: TextStyle(
                              fontSize: (18 / 720) *
                                  MediaQuery.of(context).size.height,
                              fontWeight: FontWeight.w700,
                              color: textPaint),
                        ),
                        trailing: Text(
                            '${dateTimeFormatter.timeDifference(snapshot.data![index].addedAt)} ago'),
                        onTap: () {
                          routeController.push(
                              context,
                              JobInfoView(
                                jobId: snapshot.data![index].id,
                              ));
                        },
                      ));
                },
              );
            }
            if (kDebugMode) {
              print(snapshot.connectionState);
            }
            return Center(
              child: CircularProgressIndicator(
                color: textPaint,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: textPaint,
        onPressed: null,
        child: Icon(
          Icons.add_outlined,
          color: paint,
        ),
      ),
    );
  }
}
