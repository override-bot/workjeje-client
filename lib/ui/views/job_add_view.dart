import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/job_model.dart';
import 'package:workjeje/core/viewmodels/client_view_model.dart';
import 'package:workjeje/core/viewmodels/jobs_view_models.dart';
import 'package:workjeje/ui/shared/custom_textfield.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/authentication.dart';
import '../../core/services/location.dart';
import '../../core/services/queries.dart';

class AddJob extends StatefulWidget {
  @override
  AddJobState createState() => AddJobState();
}

class AddJobState extends State<AddJob> {
  FirebaseQueries firebaseQueries = FirebaseQueries();
  final User? user = auth.currentUser;
  Color blue = Color.fromARGB(255, 14, 140, 172);
  bool? isjbdp;
  bool? islct;
  List? categories;
  bool? isjbt;
  TextEditingController _jobDescription = TextEditingController();
  TextEditingController _location = TextEditingController();
  bool isLoading = false;
  String category = 'Security';
  String? _selectedValue;
  List? subcategories;
  @override
  Widget build(BuildContext context) {
    final jobViewModel = Provider.of<JobViewModel>(context);
    final clientViewModel = Provider.of<ClientViewModel>(context);
    final locationService = Provider.of<LocationService>(context);
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    _location.text = locationService.location!;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: paint,
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: textPaint),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Container(
            color: paint,
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder<DocumentSnapshot>(
                future: firebaseQueries.getCategoryDoc(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    categories = data['Category'];
                    subcategories = data[category];
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Text(
                                "Add New Job",
                                style: GoogleFonts.lato(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: blue),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: textPaint)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(canvasColor: paint),
                                  child: DropdownButton(
                                    underline: Text(''),
                                    iconEnabledColor: textPaint,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    value: category,
                                    hint: Text(
                                      'Occupation',
                                      style: TextStyle(
                                          color: textPaint,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        print(value);
                                        _selectedValue = null;
                                        category = value.toString();
                                      });
                                    },
                                    items: categories!.map((val) {
                                      return DropdownMenuItem(
                                        value: val,
                                        child: Text(
                                          val,
                                          style: TextStyle(
                                              fontSize: 15, color: textPaint),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: textPaint)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                width: MediaQuery.of(context).size.width / 1.2,
                                child: Theme(
                                  data: Theme.of(context)
                                      .copyWith(canvasColor: paint),
                                  child: DropdownButton(
                                    iconEnabledColor: textPaint,
                                    underline: Text(''),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    value: _selectedValue,
                                    hint: Text(
                                      'Subcategory',
                                      style: TextStyle(
                                          color: textPaint,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedValue = value.toString();
                                      });
                                    },
                                    items: subcategories!.map((val) {
                                      return DropdownMenuItem(
                                        value: val,
                                        child: Text(
                                          val,
                                          style: TextStyle(
                                              fontSize: 15, color: textPaint),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                )),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            width: MediaQuery.of(context).size.width / 1.1,
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: TextField(
                              controller: _jobDescription,
                              minLines: 5,
                              maxLines: 10,
                              maxLength: 300,
                              decoration: InputDecoration(
                                  hintText: "job description here",
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: blue)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: textPaint,
                                  )),
                                  errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.red,
                                  )),
                                  focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.red,
                                  )),
                                  errorText: isjbdp == false
                                      ? "more than 3 characters"
                                      : null),
                              onChanged: (text) {
                                if (text.length < 3) {
                                  setState(() {
                                    isjbdp = false;
                                  });
                                } else {
                                  setState(() {
                                    isjbdp = true;
                                  });
                                }
                              },
                            ),
                          ),
                          CustomTextField(
                            hintText: "Nsukka",
                            labelText: "Location",
                            isEnabled: false,
                            // enabled: false,
                            controller: _location,
                          ),
                          isLoading == false
                              ? Container(
                                  margin: EdgeInsets.only(top: 20.0),
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: 50,
                                  color: blue,
                                  child: MaterialButton(
                                    child: Text(
                                      'Upload Job',
                                      style: TextStyle(
                                          color: paint,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: isjbdp == true &&
                                            // ignore: unnecessary_null_comparison
                                            category != null &&
                                            _selectedValue != null &&
                                            isLoading == false
                                        ? () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            var result = await clientViewModel
                                                .getProviderById(user!.uid);

                                            jobViewModel
                                                .addJobs(Jobs(
                                                    employerId: user!.uid,
                                                    addedAt: DateTime.now(),
                                                    jobCategory:
                                                        _selectedValue!,
                                                    jobDescription:
                                                        _jobDescription.text,
                                                    location: locationService
                                                        .location!,
                                                    phoneNumber:
                                                        result.phoneNumber!,
                                                    username: result.username!))
                                                .then((value) {
                                              Navigator.of(context).pop();
                                            }).catchError((e) {
                                              // this.showAlert(e.message);
                                              isLoading = false;
                                            });
                                          }
                                        : null,
                                  ))
                              : Container(
                                  child: Center(
                                      child: CircularProgressIndicator()))
                        ],
                      ),
                    );
                  }
                  return Container();
                })));
  }
}
