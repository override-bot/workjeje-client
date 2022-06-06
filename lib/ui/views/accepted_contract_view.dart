import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/contract_model.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/authentication.dart';

import '../../core/viewmodels/contract_view_model.dart';
import '../../utils/stringManip.dart';
import '../shared/contract_pageview.dart';

class FinalizedContracts extends StatefulWidget {
  @override
  _FinalizedContractsState createState() => _FinalizedContractsState();
}

class _FinalizedContractsState extends State<FinalizedContracts> {
  List<Contracts> contracts = [];
  final User? user = auth.currentUser;
  StringManip stringManip = StringManip();
  Random random = new Random();
  List colors = [
    Colors.red[700],
    Colors.yellow[700],
    Colors.purple[700],
    Colors.blue[700],
    Colors.green[700],
  ];
  @override
  Widget build(BuildContext context) {
    // FirebaseQueries firebaseQueries = FirebaseQueries();
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color? background = isDark == false
        ? Color.fromARGB(255, 237, 241, 241)
        : Color.fromARGB(160, 0, 0, 0);
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    final contractViewModel = Provider.of<ContractViewModel>(context);
    return Scaffold(
      body: Container(
        color: background,
        child: StreamBuilder(
            stream: contractViewModel.getAcceptedContracts(user!.uid),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (!snapshot.hasData) {
                print(user!.uid);
                return Center(
                    child: CircularProgressIndicator(
                  color: textPaint,
                ));
              }
              contracts = snapshot.data!.docs
                  // ignore: unnecessary_cast
                  .map((doc) => Contracts.fromMap(doc.data() as Map, doc.id))
                  .toList();
              if (contracts.isEmpty) {
                return Container(
                  child: Center(
                    child: Text('Oops,\nYou have no accepted contract yet',
                        style: TextStyle(
                            color: isDark == false
                                ? Color(0xFFB14181c)
                                : Colors.white,
                            fontSize:
                                (18 / 720) * MediaQuery.of(context).size.height,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              } else {
                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot<Map<String, dynamic>> document) {
                    return Container(
                        height: 90,
                        margin: EdgeInsets.only(
                            top: 10, bottom: 5, left: 7, right: 7),
                        width: MediaQuery.of(context).size.width / 1.7,
                        decoration: BoxDecoration(
                          color: paint,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListTile(
                          onTap: () {
                            showMaterialModalBottomSheet(
                                context: context,
                                enableDrag: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(35),
                                    topRight: Radius.circular(35),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (context) {
                                  return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.6,
                                      child: ContractPageView(
                                        contractId: document.id,
                                        contractTerms:
                                            document.data()!['ContractTerms'],
                                        jobDescription:
                                            document.data()!['JobDescription'],
                                      ));
                                });
                          },
                          title: Text(
                            '${document.data()!['EmployeeName']}'
                                .capitalizeFirstofEach,
                            style: TextStyle(
                                fontSize: (13 / 720) *
                                    MediaQuery.of(context).size.height,
                                fontWeight: FontWeight.w500,
                                color: textPaint),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: colors[random.nextInt(5)],
                            child: Text(
                              stringManip.getFirstLetter(
                                  document.data()!['EmployeeName']),
                              style: TextStyle(
                                  fontSize: (22 / 720) *
                                      MediaQuery.of(context).size.height,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          trailing: document.data()!['Status'] == "Accepted"
                              ? Icon(Icons.check, color: Colors.green)
                              : document.data()!['Status'] == "Rejected"
                                  ? Icon(Icons.cancel, color: Colors.red)
                                  : Icon(Icons.pending),
                          subtitle: Text(
                            '${document.data()!['JobCategory']} job'
                                .capitalizeFirstofEach,
                            style: TextStyle(
                                fontSize: (15 / 720) *
                                    MediaQuery.of(context).size.height,
                                fontWeight: FontWeight.w600,
                                color: textPaint),
                          ),
                        ));
                  }).toList(),
                );
              }
            }),
      ),
    );
  }
}
