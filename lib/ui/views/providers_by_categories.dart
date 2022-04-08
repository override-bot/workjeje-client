// ignore_for_file: import_of_legacy_library_into_null_safe, use_key_in_widget_constructors, prefer_const_constructors, use_full_hex_values_for_flutter_colors, avoid_unnecessary_containers

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/clientmodel.dart';
import 'package:workjeje/core/models/provider_model.dart';
import 'package:workjeje/core/viewmodels/client_view_model.dart';
import 'package:workjeje/core/viewmodels/providers_view_model.dart';
import 'package:workjeje/ui/views/providerDetails.dart';
import 'package:workjeje/utils/datetime.dart';
import 'package:workjeje/utils/router.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';

class ProvidersByCategory extends StatefulWidget {
  final String category;
  const ProvidersByCategory({
    required this.category,
  });
  @override
  _ProvidersByCategoryState createState() => _ProvidersByCategoryState();
}

class _ProvidersByCategoryState extends State<ProvidersByCategory> {
  FirebaseQueries firebaseQueries = FirebaseQueries();
  DateTimeFormatter dateTimeFormatter = DateTimeFormatter();
  RouteController routeController = RouteController();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    final providerViewModel = Provider.of<ProviderViewModel>(context);
    final clientViewModel = Provider.of<ClientViewModel>(context);
    bool isDark = themeStatus.darkTheme;
    Color? background =
        isDark == false ? Color.fromARGB(255, 237, 241, 241) : Colors.black26;

    Color paint = isDark == true
        ? Color(0xFFB14181c)
        : Color.fromARGB(255, 255, 255, 255);
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category,
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
          width: double.infinity,
          height: double.infinity,
          color: background,
          child: FutureBuilder<Client>(
              future: clientViewModel.getProviderById(user!.uid),
              builder: (context, userData) {
                final Distance distance = Distance();

                return FutureBuilder<List<ServiceProvider>>(
                    future: providerViewModel
                        .streamProvidersByCategories(widget.category),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (kDebugMode) {
                          print(snapshot.data);
                        }

                        if (snapshot.data!.isEmpty) {
                          return Center(
                              child: Container(
                                  child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person_off,
                                color: textPaint,
                                size: 30,
                              ),
                              Container(
                                height: 15,
                              ),
                              Text(
                                "No provider with this skill...YET",
                                style: TextStyle(
                                  color: textPaint,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          )));
                        }
                        return Container(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: paint),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        routeController.push(
                                            context,
                                            ProviderDetails(
                                              providerId:
                                                  snapshot.data![index].id!,
                                              lat: userData.data!.userLat!,
                                              long: userData.data!.userLong!,
                                            ));
                                      },
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        backgroundImage: NetworkImage(
                                            snapshot.data![index].imageurl),
                                      ),
                                      title: Text(
                                        snapshot.data![index].username,
                                        style: TextStyle(
                                            color: textPaint,
                                            fontSize: (17 / 720) *
                                                MediaQuery.of(context)
                                                    .size
                                                    .height,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      subtitle: Text(
                                        'last active ${dateTimeFormatter.timeDifference(snapshot.data![index].lastSeen)} ago',
                                        style: TextStyle(
                                          color: textPaint,
                                          fontSize: (14 / 720) *
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                        ),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: 70),
                                        child: Row(children: [
                                          RichText(
                                              text: TextSpan(children: [
                                            WidgetSpan(
                                                child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 3),
                                              child: Icon(
                                                Icons.location_pin,
                                                color: textPaint,
                                                size: 18,
                                              ),
                                            )),
                                            TextSpan(
                                                style: TextStyle(
                                                    fontSize: (14 / 720) *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    fontWeight: FontWeight.w400,
                                                    color: textPaint),
                                                text:
                                                    "${distance.as(LengthUnit.Kilometer, LatLng(snapshot.data![index].userLat, snapshot.data![index].userLong), LatLng(userData.data!.userLat, userData.data!.userLong))}km")
                                          ])),
                                          Container(
                                            width: 12,
                                          ),
                                          RichText(
                                              text: TextSpan(children: [
                                            WidgetSpan(
                                                child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 0, right: 3),
                                              child: Icon(
                                                Icons.work,
                                                color: textPaint,
                                                size: 18,
                                              ),
                                            )),
                                            TextSpan(
                                                style: TextStyle(
                                                    fontSize: (14 / 720) *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    fontWeight: FontWeight.w400,
                                                    color: textPaint),
                                                text:
                                                    '${snapshot.data![index].jobs}')
                                          ])),
                                          Container(
                                            width: 12,
                                          ),
                                          RichText(
                                              text: TextSpan(children: [
                                            WidgetSpan(
                                                child: Container(
                                              margin: EdgeInsets.only(
                                                  left: 5, right: 3),
                                              child: Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 18,
                                              ),
                                            )),
                                            TextSpan(
                                                style: TextStyle(
                                                    fontSize: (14 / 720) *
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                    fontWeight: FontWeight.w500,
                                                    color: textPaint),
                                                text:
                                                    "${(snapshot.data![index].rating / snapshot.data![index].raters).floorToDouble()}")
                                          ])),
                                        ])),
                                    Container(
                                      height: 5,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: textPaint,
                          ),
                        );
                      }
                    });
              }),
        ));
  }
}
