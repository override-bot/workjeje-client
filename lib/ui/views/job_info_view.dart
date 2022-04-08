// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, use_full_hex_values_for_flutter_colors, sized_box_for_whitespace, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/job_model.dart';
import 'package:workjeje/ui/views/bids_view.dart';
import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';
import '../../core/viewmodels/jobs_view_models.dart';
import '../../utils/datetime.dart';
import '../../utils/router.dart';
import '../../utils/stringManip.dart';

class JobInfoView extends StatefulWidget {
  final String? jobId;
  JobInfoView({this.jobId});
  @override
  JobInfoViewState createState() => JobInfoViewState();
}

class JobInfoViewState extends State<JobInfoView> {
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
    Color? background =
        isDark == false ? Color.fromARGB(255, 237, 241, 241) : Colors.black26;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Details",
          style: TextStyle(
              fontSize: (15 / 720) * MediaQuery.of(context).size.height,
              color: textPaint,
              fontWeight: FontWeight.w600),
        ),
        elevation: 0.0,
        backgroundColor: background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textPaint,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        color: background,
        child: FutureBuilder<Jobs>(
          future: jobViewModel.getJobsById(widget.jobId),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 10,
                    ),
                    CircleAvatar(
                        radius: MediaQuery.of(context).size.height / 15,
                        backgroundColor: textPaint,
                        // backgroundImage: NetworkImage(snapshot.data!.i),
                        child: Text(
                          stringManip.getFirstLetter(snapshot.data!.username),
                          style: TextStyle(color: paint, fontSize: 32),
                        )),
                    Container(
                      height: 10,
                    ),
                    Text(snapshot.data!.username,
                        style: TextStyle(
                            fontSize:
                                (16 / 720) * MediaQuery.of(context).size.height,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[500])),
                    Container(
                      height: 5,
                    ),
                    Text(snapshot.data!.jobCategory.capitalizeFirstofEach,
                        style: TextStyle(
                            fontSize:
                                (22 / 720) * MediaQuery.of(context).size.height,
                            fontWeight: FontWeight.w700,
                            color: textPaint)),
                    Container(
                      height: 5,
                    ),
                    Container(
                        //margin: EdgeInsets.only(left: 70),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                WidgetSpan(
                                    child: Container(
                                  margin: EdgeInsets.only(left: 0, right: 3),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: textPaint,
                                    size: 18,
                                  ),
                                )),
                                TextSpan(
                                    style: TextStyle(
                                        fontSize: (14 / 720) *
                                            MediaQuery.of(context).size.height,
                                        fontWeight: FontWeight.w400,
                                        color: textPaint),
                                    text: dateTimeFormatter.displayFullDate(
                                        snapshot.data!.addedAt))
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                WidgetSpan(
                                    child: Container(
                                  margin: EdgeInsets.only(left: 0, right: 3),
                                  child: Icon(
                                    Icons.location_pin,
                                    color: textPaint,
                                    size: 18,
                                  ),
                                )),
                                TextSpan(
                                    style: TextStyle(
                                        fontSize: (14 / 720) *
                                            MediaQuery.of(context).size.height,
                                        fontWeight: FontWeight.w400,
                                        color: textPaint),
                                    text: '${snapshot.data!.location}')
                              ])),
                            ])),
                    Container(
                      height: 15,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Text("Job Description",
                          style: TextStyle(
                              fontSize: (18 / 720) *
                                  MediaQuery.of(context).size.height,
                              fontWeight: FontWeight.w600,
                              color: textPaint)),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Text(snapshot.data!.jobDescription,
                          style: TextStyle(
                              fontSize: (14 / 720) *
                                  MediaQuery.of(context).size.height,
                              fontWeight: FontWeight.w400,
                              color: textPaint)),
                    ),
                    Container(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      // color: textPaint,
                      height: 50,
                      decoration: BoxDecoration(
                          color: textPaint,
                          borderRadius: BorderRadius.circular(15)),
                      child: MaterialButton(
                        onPressed: () {
                          routeController.push(
                              context,
                              BidView(
                                jobId: widget.jobId,
                              ));
                        },
                        child: Text("View Bids",
                            style: TextStyle(
                                fontSize: (14 / 720) *
                                    MediaQuery.of(context).size.height,
                                fontWeight: FontWeight.w400,
                                color: paint)),
                      ),
                    )
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: textPaint,
              ),
            );
          },
        ),
      ),
    );
  }
}
