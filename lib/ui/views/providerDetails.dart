import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/provider_model.dart';
import 'package:workjeje/ui/shared/option_box.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';
import '../../core/viewmodels/providers_view_model.dart';
import '../../utils/datetime.dart';
import '../../utils/router.dart';

class ProviderDetails extends StatefulWidget {
  final double lat;
  final double long;
  final String providerId;
  ProviderDetails(
      {required this.providerId, required this.lat, required this.long});
  ProviderDetailsState createState() => ProviderDetailsState();
}

class ProviderDetailsState extends State<ProviderDetails> {
  FirebaseQueries firebaseQueries = FirebaseQueries();
  DateTimeFormatter dateTimeFormatter = DateTimeFormatter();
  RouteController routeController = RouteController();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    final providerViewModel = Provider.of<ProviderViewModel>(context);
    // final clientViewModel = Provider.of<ClientViewModel>(context);
    bool isDark = themeStatus.darkTheme;
    Color? background =
        isDark == false ? Color.fromARGB(255, 231, 239, 240) : Colors.black26;

    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textPaint,
          ),
          onPressed: () {
            routeController.pop(context);
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        color: background,
        child: FutureBuilder<ServiceProvider>(
          future: providerViewModel.getProviderById(widget.providerId),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                color: textPaint,
              ));
            }
            final Distance distance = Distance();
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 7),
                  ),
                  CircleAvatar(
                    backgroundColor: textPaint,
                    backgroundImage: NetworkImage(snapshot.data!.imageurl),
                    radius: MediaQuery.of(context).size.height / 10,
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    snapshot.data!.username,
                    style: TextStyle(
                        color: textPaint,
                        fontWeight: FontWeight.w500,
                        fontSize:
                            20 / 720 * MediaQuery.of(context).size.height),
                  ),
                  Container(
                    height: 16,
                  ),
                  Text(
                    snapshot.data!.occupation,
                    style: TextStyle(
                        color: textPaint,
                        fontWeight: FontWeight.w400,
                        fontSize:
                            16 / 720 * MediaQuery.of(context).size.height),
                  ),
                  Container(
                    height: 16,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      snapshot.data!.skill.join(" | "),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: textPaint,
                          fontWeight: FontWeight.w400,
                          fontSize:
                              16 / 720 * MediaQuery.of(context).size.height),
                    ),
                  ),
                  Container(
                    height: 16,
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
                                  text:
                                      "${distance.as(LengthUnit.Kilometer, LatLng(snapshot.data!.userLat, snapshot.data!.userLong), LatLng(widget.lat, widget.long))}km")
                            ])),
                            RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                  child: Container(
                                margin: EdgeInsets.only(left: 0, right: 3),
                                child: Icon(
                                  Icons.work,
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
                                  text: '${snapshot.data!.jobs}')
                            ])),
                            RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                  child: Container(
                                margin: EdgeInsets.only(left: 5, right: 3),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 18,
                                ),
                              )),
                              TextSpan(
                                  style: TextStyle(
                                      fontSize: (14 / 720) *
                                          MediaQuery.of(context).size.height,
                                      fontWeight: FontWeight.w500,
                                      color: textPaint),
                                  text:
                                      "${(snapshot.data!.rating / snapshot.data!.raters).floorToDouble()}")
                            ])),
                          ])),
                  Container(height: 14.0),
                  ListTile(
                    leading:
                        Icon(Icons.monetization_on_outlined, color: textPaint),
                    title: Text(
                      "Rate Card",
                      style: TextStyle(
                          fontSize:
                              (14 / 720) * MediaQuery.of(context).size.height,
                          fontWeight: FontWeight.w500,
                          color: isDark == true ? Colors.white : Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: textPaint),
                  ),
                  Container(height: 7.0),
                  ListTile(
                    leading:
                        Icon(Icons.pending_actions_outlined, color: textPaint),
                    title: Text(
                      "Send Contract",
                      style: TextStyle(
                          fontSize:
                              (14 / 720) * MediaQuery.of(context).size.height,
                          fontWeight: FontWeight.w500,
                          color: isDark == true ? Colors.white : Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: textPaint),
                  ),
                  Container(height: 7.0),
                  ListTile(
                    leading:
                        Icon(Icons.calendar_today_outlined, color: textPaint),
                    title: Text(
                      "View Schedule",
                      style: TextStyle(
                          fontSize:
                              (14 / 720) * MediaQuery.of(context).size.height,
                          fontWeight: FontWeight.w500,
                          color: isDark == true ? Colors.white : Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: textPaint),
                  ),
                  Container(height: 7.0),
                  ListTile(
                    leading: Icon(Icons.star_outline, color: textPaint),
                    title: Text(
                      "Reviews",
                      style: TextStyle(
                          fontSize:
                              (14 / 720) * MediaQuery.of(context).size.height,
                          fontWeight: FontWeight.w500,
                          color: isDark == true ? Colors.white : Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: textPaint),
                  ),
                  Container(height: 7.0),
                  ListTile(
                    leading: Icon(Icons.image_outlined, color: textPaint),
                    title: Text(
                      "View Gallery",
                      style: TextStyle(
                          fontSize:
                              (14 / 720) * MediaQuery.of(context).size.height,
                          fontWeight: FontWeight.w500,
                          color: isDark == true ? Colors.white : Colors.black),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: textPaint),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
