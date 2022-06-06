import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workjeje/core/models/contract_model.dart';
import 'package:workjeje/core/services/notification_helper.dart';
import 'package:workjeje/core/viewmodels/providers_view_model.dart';
import 'package:workjeje/ui/shared/popup.dart';
import 'package:workjeje/ui/shared/rateBox.dart';
import 'package:workjeje/utils/router.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/authentication.dart';
import '../../core/viewmodels/contract_view_model.dart';
import '../../utils/stringManip.dart';

class ContractDetails extends StatefulWidget {
  final PageController page;
  final String? contractId;
  ContractDetails({required this.contractId, required this.page});
  @override
  ContractDetailsState createState() => ContractDetailsState();
}

class ContractDetailsState extends State<ContractDetails> {
  StringManip stringManip = StringManip();
  NotificationHelper _helper = NotificationHelper();
  final User? user = auth.currentUser;
  @override
  Widget build(BuildContext context) {
    final contractViewModel = Provider.of<ContractViewModel>(context);
    final providerViewModel = Provider.of<ProviderViewModel>(context);
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color textPaint = isDark == false ? const Color(0xFFB14181c) : Colors.white;

    return FutureBuilder<Contracts>(
      future: contractViewModel.getContractsByID(widget.contractId, user!.uid),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
              child: Column(
            children: [
              Container(
                height: 15,
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.amber,
                child: Text(
                  stringManip.getFirstLetter(snapshot.data!.employeeName),
                  style: TextStyle(
                      fontSize: (20 / 720) * MediaQuery.of(context).size.height,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 15,
              ),
              Text(
                snapshot.data!.employeeName,
                style: TextStyle(
                    fontSize: (15 / 720) * MediaQuery.of(context).size.height,
                    color: textPaint,
                    fontWeight: FontWeight.w600),
              ),
              Container(
                height: 5,
              ),
              Text(
                snapshot.data!.jobCategory,
                style: TextStyle(
                    fontSize: (13 / 720) * MediaQuery.of(context).size.height,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400),
              ),
              Container(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (snapshot.data!.status == "Accepted") {
                          final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: snapshot.data!.employeePhoneNumber,
                          );
                          await launch(launchUri.toString());
                        } else {
                          PopUp().showError(
                              "Contract must be accepted first", context);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.call,
                                size: 25,
                                color: Colors.blue,
                              )),
                          Container(
                            height: 2,
                          ),
                          Container(
                            //   width: 50,
                            child: const Text(
                              "Contact\nDetails",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.page.jumpToPage(1);
                      },
                      child: Column(
                        children: [
                          Container(
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.pending_actions,
                                size: 25,
                                color: Colors.blue,
                              )),
                          Container(
                            height: 2,
                          ),
                          Container(
                            //   width: 50,
                            child: const Text(
                              "Contract\nTerms",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        widget.page.jumpToPage(2);
                      },
                      child: Column(
                        children: [
                          Container(
                              width: 50,
                              height: 50,
                              child: const Icon(
                                Icons.work,
                                size: 25,
                                color: Colors.blue,
                              )),
                          Container(
                            height: 2,
                          ),
                          Container(
                            //   width: 50,
                            child: Text(
                              "Job\nDescription",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: textPaint,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 40, top: 40),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "You sent a job contract",
                  style: TextStyle(
                      fontSize: (13 / 720) * MediaQuery.of(context).size.height,
                      color: textPaint,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
                color: textPaint,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 20),
                child: ListTile(
                  onTap: () async {
                    var result = await providerViewModel
                        .getProviderById(snapshot.data!.employeeId);
                    if (snapshot.data!.status == "Accepted") {
                      contractViewModel
                          .completeContract(snapshot.data!.employerId,
                              snapshot.data!.id, snapshot.data!.employeeId)
                          .then((value) {
                        Navigator.pop(context);
                        _helper.sendMesssage(result.token, "Contract",
                            "Your contract with ${snapshot.data!.employerName} has been completed");
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: RateBox(
                                providerId: snapshot.data!.employeeId,
                              ));
                            });

                        setState(() {});
                      });
                    } else {
                      PopUp().showError(
                          "Contract must be accepted first", context);
                    }
                  },
                  leading: Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: textPaint,
                    size: 15,
                  ),
                  title: Text(
                    "Complete contract",
                    style: TextStyle(
                        fontSize:
                            (13 / 720) * MediaQuery.of(context).size.height,
                        color: textPaint,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
                color: textPaint,
              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 20),
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: FittedBox(
                              fit: BoxFit.contain,
                              //  width: MediaQuery.of(context).size.width / 1.1,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.dangerous,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    "Are you sure you want to cancel?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: MaterialButton(
                                              onPressed: () {
                                                RouteController().pop(context);
                                              },
                                              child: Text(
                                                "Back",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: Colors.blue)),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.5,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.blue,
                                            ),
                                            child: MaterialButton(
                                              onPressed: () async {
                                                var result =
                                                    await providerViewModel
                                                        .getProviderById(
                                                            snapshot.data!
                                                                .employeeId);
                                                contractViewModel
                                                    .cancelContract(
                                                        snapshot.data!.id,
                                                        user!.uid,
                                                        snapshot
                                                            .data!.employeeId);

                                                RouteController().pop(context);
                                                _helper.sendMesssage(
                                                    result.token,
                                                    "Contract",
                                                    "Your contract with ${snapshot.data!.employerName} has been canceled");
                                                RouteController().pop(context);
                                                setState(() {});
                                              },
                                              child: Text(
                                                "Cancel",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  leading: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: textPaint,
                    size: 15,
                  ),
                  title: Text(
                    "Cancel contract",
                    style: TextStyle(
                        fontSize:
                            (13 / 720) * MediaQuery.of(context).size.height,
                        color: textPaint,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "Make sure job has been completed satisfactorily before confirming completion",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: (13 / 720) * MediaQuery.of(context).size.height,
                      color: Colors.red,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ));
        } else if (snapshot.hasError) {
          return Center(
              child: Container(
            //margin: EdgeInsets.only(left: 40, top: 40),
            child: Text(
              "This contract has been canceled",
              style: TextStyle(
                  fontSize: (16 / 720) * MediaQuery.of(context).size.height,
                  color: Colors.red,
                  fontWeight: FontWeight.w600),
            ),
          ));
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: textPaint,
            ),
          );
        }
      },
    );
  }
}
