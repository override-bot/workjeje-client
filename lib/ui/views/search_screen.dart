import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/services/location.dart';
import 'package:workjeje/core/viewmodels/client_view_model.dart';
import 'package:workjeje/ui/views/providerDetails.dart';
import 'package:workjeje/utils/router.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';
import '../../utils/datetime.dart';
import '../../utils/stringManip.dart';

class SearchScreen extends StatefulWidget {
  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  StringManip stringManip = StringManip();
  DateTimeFormatter time = DateTimeFormatter();
  TextEditingController _searchField = TextEditingController();
  String searchKey = "";
  String field = "";
  Stream? streamQuery;
  //  FirebaseFirestore.instance.collection('providers').limit(1).snapshots();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    ThemeProvider themeProvider = ThemeProvider();
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    IconData darkIcon = Icons.person;
    final clientViewModel = Provider.of<ClientViewModel>(context);
    final locationService = Provider.of<LocationService>(context);
    Color? background = isDark == false
        ? Color.fromARGB(255, 237, 241, 241)
        : Color.fromARGB(160, 0, 0, 0);
    return SafeArea(
      child: Scaffold(
        body: Container(
            height: double.infinity,
            color: background,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 15),
                      child: Text(
                        "Search",
                        style: TextStyle(
                            color: textPaint,
                            fontWeight: FontWeight.w600,
                            fontSize: (26 / 720) *
                                MediaQuery.of(context).size.height),
                      )),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    height: 50,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: TextFormField(
                      controller: _searchField,
                      //keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          searchKey = value.capitalizeFirstofEach;
                          streamQuery = FirebaseFirestore.instance
                              .collection('providers')
                              .where(field, isGreaterThanOrEqualTo: searchKey)
                              .where(field, isLessThan: searchKey + 'z')
                              .limit(5)
                              .snapshots();
                        });
                      },
                      style: TextStyle(color: textPaint),
                      decoration: InputDecoration(
                        hintText: "eg. Plumber",
                        prefixIcon: Icon(Icons.search, color: textPaint),
                        labelText: null,
                        hintStyle: new TextStyle(
                            color: textPaint,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                        labelStyle: new TextStyle(
                            color: textPaint,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[600]!)),
                        enabledBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.grey[600]!,
                        )),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        "Filter by:",
                        style: TextStyle(
                            fontSize: 18,
                            color: textPaint,
                            fontWeight: FontWeight.w600),
                      )),
                  Container(height: 3),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: 0.0, bottom: 2, left: 5),
                              height: 30,
                              color: field == 'occupation'
                                  ? Colors.green
                                  : textPaint,
                              child: MaterialButton(
                                  child: Text(
                                    "Occupation",
                                    style: TextStyle(color: paint),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      field = 'occupation';
                                    });
                                  }))),
                      Expanded(
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: 0.0, bottom: 2, left: 5),
                              height: 30,
                              color: field == 'username'
                                  ? Colors.green
                                  : textPaint,
                              child: MaterialButton(
                                  child: Text(
                                    "Name",
                                    style: TextStyle(color: paint),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      field = 'username';
                                    });
                                  }))),
                      Expanded(
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: 0.0, bottom: 2, left: 5, right: 5),
                              height: 30,
                              color: field == 'location'
                                  ? Colors.green
                                  : textPaint,
                              child: MaterialButton(
                                  child: Text(
                                    "Location",
                                    style: TextStyle(color: paint),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      field = 'location';
                                    });
                                  })))
                    ],
                  ),
                  Container(height: 3),
                  StreamBuilder(
                      stream: streamQuery,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                              height: 450,
                              width: double.infinity,
                              child: ListView(
                                children: snapshot.data.docs.map<Widget>(
                                    (DocumentSnapshot<Map<String, dynamic>>
                                        document) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: 7, right: 7, top: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: ListTile(
                                      onTap: () {
                                        RouteController().push(
                                            context,
                                            ProviderDetails(
                                                providerId: document.id,
                                                lat: locationService.userLat!,
                                                long:
                                                    locationService.userLong!));
                                      },
                                      title: Text(document.data()!['username'],
                                          style: TextStyle(
                                              fontSize: (17 / 720) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              fontWeight: FontWeight.w600,
                                              color: textPaint)),
                                      subtitle: Text(
                                          document.data()!['occupation'],
                                          style: TextStyle(
                                              fontSize: (15 / 720) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              fontWeight: FontWeight.w500,
                                              color: textPaint)),
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            document.data()!['imageurl']),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ));
                        } else {
                          return Container(color: paint, child: Container());
                        }
                      }),
                ],
              ),
            )),
      ),
    );
  }
}
