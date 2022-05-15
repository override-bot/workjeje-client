// ignore_for_file: use_full_hex_values_for_flutter_colors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/bid_model.dart';
import 'package:workjeje/core/models/contract_model.dart';
import 'package:workjeje/core/models/provider_model.dart';
import 'package:workjeje/core/services/notification_helper.dart';
import 'package:workjeje/core/viewmodels/bids_view_model.dart';
import 'package:workjeje/core/viewmodels/client_view_model.dart';
import 'package:workjeje/core/viewmodels/contract_view_model.dart';
import 'package:workjeje/core/viewmodels/providers_view_model.dart';
import 'package:workjeje/ui/shared/popup.dart';
import 'package:workjeje/ui/views/providerDetails.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';
import '../../core/viewmodels/jobs_view_models.dart';
import '../../utils/datetime.dart';
import '../../utils/router.dart';
import '../../utils/stringManip.dart';

class BidView extends StatefulWidget {
  final String? jobId;
  const BidView({Key? key, this.jobId}) : super(key: key);
  @override
  BidViewState createState() => BidViewState();
}

class BidViewState extends State<BidView> {
  FirebaseQueries firebaseQueries = FirebaseQueries();
  DateTimeFormatter dateTimeFormatter = DateTimeFormatter();
  RouteController routeController = RouteController();
  StringManip stringManip = StringManip();
  NotificationHelper _helper = NotificationHelper();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    final jobViewModel = Provider.of<JobViewModel>(context);
    final bidViewModel = Provider.of<BidsViewModel>(context);
    final providerViewModel = Provider.of<ProviderViewModel>(context);
    final contractViewModel = Provider.of<ContractViewModel>(context);
    final clientViewModel = Provider.of<ClientViewModel>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? const Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? const Color(0xFFB14181c) : Colors.white;
    Color? background = isDark == false
        ? const Color.fromARGB(255, 237, 241, 241)
        : Colors.black26;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bids",
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
        child: FutureBuilder<List<Bid>>(
          future: bidViewModel.getBids(widget.jobId),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No bids for this job yet",
                    style: TextStyle(
                        color: textPaint,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    String message = snapshot.data![index].shortMessage;
                    String bidId = snapshot.data![index].id!;

                    return FutureBuilder<ServiceProvider>(
                      future: providerViewModel
                          .getProviderById(snapshot.data![index].providerId),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: paint),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  onTap: () {
                                    showMaterialModalBottomSheet(
                                        backgroundColor: paint,
                                        context: context,
                                        enableDrag: true,
                                        elevation: 10.0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(35),
                                                topRight: Radius.circular(35))),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        //   animationCurve: ,

                                        builder: (context) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            color: paint,
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  CircleAvatar(
                                                    backgroundColor: textPaint,
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                            .data!.imageurl),
                                                    radius: 50,
                                                  ),
                                                  Container(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    snapshot.data!.username,
                                                    style: TextStyle(
                                                        color: textPaint,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18 /
                                                            720 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    snapshot.data!.occupation,
                                                    style: TextStyle(
                                                        color: textPaint,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14 /
                                                            720 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  RichText(
                                                      text: TextSpan(children: [
                                                    WidgetSpan(
                                                        child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 0,
                                                              right: 3),
                                                      child: Icon(
                                                        Icons.location_pin,
                                                        color: textPaint,
                                                        size: 14,
                                                      ),
                                                    )),
                                                    TextSpan(
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: textPaint),
                                                        text: snapshot
                                                            .data!.location)
                                                  ])),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Text(
                                                      "Message",
                                                      style: TextStyle(
                                                          color: textPaint,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14 /
                                                              720 *
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    message,
                                                    style: TextStyle(
                                                        color: textPaint,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 14 /
                                                            720 *
                                                            MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height),
                                                  ),
                                                  Container(
                                                    height: 15,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.4,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            routeController.push(
                                                                context,
                                                                ProviderDetails(
                                                                    providerId:
                                                                        snapshot
                                                                            .data!
                                                                            .id!,
                                                                    lat: 3.1,
                                                                    long: 3.2));
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25)),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .person,
                                                                    size: 30,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              Container(
                                                                height: 4,
                                                              ),
                                                              Container(
                                                                //   width: 50,
                                                                child:
                                                                    const Text(
                                                                  "View Profile",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            TextEditingController
                                                                termsField =
                                                                TextEditingController();
                                                            bool? isTerms;
                                                            showMaterialModalBottomSheet(
                                                                backgroundColor:
                                                                    paint,
                                                                elevation: 20,
                                                                context:
                                                                    context,
                                                                enableDrag:
                                                                    true,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                                35),
                                                                        topRight:
                                                                            Radius.circular(
                                                                                35))),
                                                                clipBehavior: Clip
                                                                    .antiAliasWithSaveLayer,
                                                                //   animationCurve: ,

                                                                builder:
                                                                    (context) {
                                                                  return Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    color:
                                                                        paint,
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Container(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          const Text(
                                                                            "Send Contract",
                                                                            style:
                                                                                TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(top: 25),
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 1.1,
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                            ),
                                                                            child:
                                                                                TextField(
                                                                              controller: termsField,
                                                                              minLines: 15,
                                                                              maxLines: 20,
                                                                              maxLength: 500,
                                                                              decoration: InputDecoration(
                                                                                  hintText: "Contract terms here..",
                                                                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: textPaint)),
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
                                                                                  errorText: isTerms == false ? "more than 3 characters" : null),
                                                                              onChanged: (text) {
                                                                                if (text.length < 3) {
                                                                                  setState(() {
                                                                                    isTerms = false;
                                                                                  });
                                                                                } else {
                                                                                  setState(() {
                                                                                    isTerms = true;
                                                                                  });
                                                                                }
                                                                              },
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 1.3,
                                                                            height:
                                                                                60,
                                                                            margin:
                                                                                const EdgeInsets.only(bottom: 10),
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: textPaint),
                                                                            child:
                                                                                MaterialButton(
                                                                              onPressed: () async {
                                                                                var userData = await clientViewModel.getProviderById(user!.uid);
                                                                                var jobData = await jobViewModel.getJobsById(widget.jobId);
                                                                                contractViewModel.sendContract(user!.uid, snapshot.data!.id, user!.uid + snapshot.data!.id!, Contracts(employeeId: snapshot.data!.id!, employerId: user!.uid, employerName: userData.username!, employeeName: snapshot.data!.username, employerPhoneNumber: userData.phoneNumber!, employeePhoneNumber: snapshot.data!.phoneNumber, createdAt: DateTime.now(), jobId: widget.jobId!, jobDescription: jobData.jobDescription, jobCategory: jobData.jobCategory, status: "Pending", contractTerms: termsField.text)).then((value) {
                                                                                  termsField.clear();
                                                                                  PopUp().showSuccess("Contract sent", context);
                                                                                  Navigator.of(context).pop();
                                                                                  _helper.sendMesssage(snapshot.data!.token, "Contract", "${userData.username} sent a contract. Head to contract page to accept or reject");
                                                                                });
                                                                                //  bidViewModel.rejectBid(bidId, widget.jobId);
                                                                              },
                                                                              child: Text(
                                                                                "Send Contract",
                                                                                style: TextStyle(color: paint, fontSize: 20),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  );
                                                                });
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .green,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25)),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .check_circle,
                                                                    size: 50,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              Container(
                                                                height: 4,
                                                              ),
                                                              Container(
                                                                //   width: 50,
                                                                child:
                                                                    const Text(
                                                                  "Accept Bid",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            bidViewModel
                                                                .rejectBid(
                                                                    bidId,
                                                                    widget
                                                                        .jobId);
                                                            routeController
                                                                .pop(context);
                                                            // _helper.sendMesssage(snapshot.data!.token, "Bid", "")
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25)),
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .cancel_rounded,
                                                                    size: 50,
                                                                    color: Colors
                                                                        .white,
                                                                  )),
                                                              Container(
                                                                height: 4,
                                                              ),
                                                              Container(
                                                                //   width: 50,
                                                                child:
                                                                    const Text(
                                                                  "Reject Bid",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 20,
                                                  )
                                                ]),
                                          );
                                        });
                                  },
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    backgroundImage:
                                        NetworkImage(snapshot.data!.imageurl),
                                  ),
                                  title: Text(
                                    snapshot.data!.username,
                                    style: TextStyle(
                                        color: textPaint,
                                        fontSize: (17 / 720) *
                                            MediaQuery.of(context).size.height,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  subtitle: Text(
                                    'last active ${dateTimeFormatter.timeDifference(snapshot.data!.lastSeen)} ago',
                                    style: TextStyle(
                                      color: textPaint,
                                      fontSize: (14 / 720) *
                                          MediaQuery.of(context).size.height,
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(left: 70),
                                    child: Row(children: [
                                      RichText(
                                          text: TextSpan(children: [
                                        WidgetSpan(
                                            child: Container(
                                          margin: const EdgeInsets.only(
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
                                            text: '${snapshot.data!.jobs}')
                                      ])),
                                      Container(
                                        width: 12,
                                      ),
                                      RichText(
                                          text: TextSpan(children: [
                                        WidgetSpan(
                                            child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 5, right: 3),
                                          child: const Icon(
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
                                                "${(snapshot.data!.rating / snapshot.data!.raters).floorToDouble()}")
                                      ])),
                                    ])),
                                Container(
                                  height: 5,
                                )
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
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
