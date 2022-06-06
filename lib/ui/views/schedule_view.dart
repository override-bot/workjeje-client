// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, unused_local_variable, prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/schedule_model.dart';
import 'package:workjeje/core/viewmodels/schedule_view_model.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../utils/datetime.dart';
import '../../utils/router.dart';
import '../../utils/stringManip.dart';

class ScheduleView extends StatefulWidget {
  final String providerId;
  ScheduleView({required this.providerId});
  @override
  ScheduleViewState createState() => ScheduleViewState();
}

class ScheduleViewState extends State<ScheduleView> {
  RouteController routeController = RouteController();
  StringManip stringManip = StringManip();
  DateTimeFormatter dateTimeFormatter = DateTimeFormatter();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    ThemeProvider themeProvider = ThemeProvider();
    final scheduleViewModel = Provider.of<ScheduleViewModel>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    IconData darkIcon = isDark == true ? Icons.dark_mode : Icons.light_mode;
    Color? background = isDark == false
        ? Color.fromARGB(255, 237, 241, 241)
        : Color.fromARGB(160, 0, 0, 0);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedule",
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
        child: FutureBuilder<List<Schedule>>(
          future: scheduleViewModel.getSchedule(widget.providerId),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No upcoming schedule...yet",
                    style: TextStyle(
                        color: textPaint,
                        fontSize:
                            (22 / 720) * MediaQuery.of(context).size.height),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      margin: EdgeInsets.only(left: 7, right: 7, top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Text(
                          dateTimeFormatter.formatDateWithLineBreak(
                              snapshot.data![index].date),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: (15 / 720) *
                                  MediaQuery.of(context).size.height),
                        ),
                        subtitle: Text(
                          snapshot.data![index].activity!.capitalizeFirstofEach,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: (13 / 720) *
                                  MediaQuery.of(context).size.height),
                        ),
                        title: Text(
                          dateTimeFormatter
                                  .displayT(snapshot.data![index].startTime)
                                  .toString() +
                              " - " +
                              dateTimeFormatter
                                  .displayT(snapshot.data![index].endTime)
                                  .toString(),
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                              fontSize: (13 / 720) *
                                  MediaQuery.of(context).size.height),
                        ),
                      ),
                    );
                  },
                );
              }
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
