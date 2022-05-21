import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/contract_model.dart';
import 'package:workjeje/core/services/authentication.dart';
import 'package:workjeje/core/viewmodels/contract_view_model.dart';
import 'package:workjeje/ui/shared/contract_pageview.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../utils/stringManip.dart';

class ContractView extends StatefulWidget {
  @override
  ContractViewState createState() => ContractViewState();
}

class ContractViewState extends State<ContractView> {
  StringManip stringManip = StringManip();
  final User? user = auth.currentUser;
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
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    Color? background = isDark == false
        ? Color.fromARGB(255, 237, 241, 241)
        : Color.fromARGB(160, 0, 0, 0);
    final contractViewModel = Provider.of<ContractViewModel>(context);
    return Container(
      height: double.infinity,
      color: background,
      child: FutureBuilder<List<Contracts>>(
        future: contractViewModel.getContracts(user!.uid),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No contract...yet",
                  style: TextStyle(
                      color: textPaint,
                      fontWeight: FontWeight.w500,
                      fontSize:
                          (24 / 720) * MediaQuery.of(context).size.height),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
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
                                      MediaQuery.of(context).size.height / 1.6,
                                  child: ContractPageView(
                                    contractId: snapshot.data![index].id!,
                                    contractTerms:
                                        snapshot.data![index].contractTerms,
                                    jobDescription:
                                        snapshot.data![index].jobDescription,
                                  ));
                            });
                      },
                      title: Text(
                        snapshot.data![index].employeeName,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: (16 / 720) *
                                MediaQuery.of(context).size.height),
                      ),
                      subtitle: Text(
                        '${snapshot.data![index].jobCategory} Job',
                        style: TextStyle(
                            color: textPaint,
                            fontWeight: FontWeight.w500,
                            fontSize: (22 / 720) *
                                MediaQuery.of(context).size.height),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: colors[random.nextInt(5)],
                        child: Text(
                          stringManip.getFirstLetter(
                              snapshot.data![index].employeeName),
                          style: TextStyle(
                              fontSize: (22 / 720) *
                                  MediaQuery.of(context).size.height,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      trailing: snapshot.data![index].status == "Accepted"
                          ? Icon(Icons.check, color: Colors.green)
                          : snapshot.data![index].status == "Rejected"
                              ? Icon(Icons.cancel, color: Colors.red)
                              : Icon(Icons.pending),
                    ),
                  );
                },
              );
            }
          }
          return (Center(
            child: CircularProgressIndicator(
              color: textPaint,
            ),
          ));
        },
      ),
    );
  }
}
