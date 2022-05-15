import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:workjeje/core/models/contract_model.dart';
import 'package:workjeje/core/services/notification_helper.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/viewmodels/client_view_model.dart';
import '../../core/viewmodels/contract_view_model.dart';
import '../../core/viewmodels/jobs_view_models.dart';
import '../../core/viewmodels/providers_view_model.dart';
import '../shared/custom_textfield.dart';

class SendContract extends StatefulWidget {
  final String userId;
  final String providerId;
  final String occupation;
  SendContract(
      {required this.userId,
      required this.providerId,
      required this.occupation});
  SendContractState createState() => SendContractState();
}

class SendContractState extends State<SendContract> {
  bool isLoading = false;
  TextEditingController _contractTerms = TextEditingController();

  TextEditingController _jobDescription = TextEditingController();
  bool? isjbtp;
  bool? isjbdp;
  bool? iscrtm;
  @override
  Widget build(BuildContext context) {
    final jobViewModel = Provider.of<JobViewModel>(context);
    final clientViewModel = Provider.of<ClientViewModel>(context);
    final providerViewModel = Provider.of<ProviderViewModel>(context);
    final contractViewModel = Provider.of<ContractViewModel>(context);
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
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
          height: double.infinity,
          width: double.infinity,
          color: paint,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Text(
                      "Send Contract:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize:
                            (20 / 720) * MediaQuery.of(context).size.height,
                        color: textPaint,
                      ),
                    )),
                CustomTextField(
                  onChanged: (text) {
                    setState(() {
                      if (text.length > 10) {
                        isjbdp = true;
                      } else {
                        isjbdp = false;
                      }
                    });
                  },
                  hintText: "skills needed are...",
                  labelText: "Job Description",
                  controller: _jobDescription,
                  errorText: isjbdp == false
                      ? "Job Description should be more than 10 characters"
                      : null,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  width: MediaQuery.of(context).size.width / 1.1,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    controller: _contractTerms,
                    minLines: 15,
                    maxLines: 20,
                    maxLength: 500,
                    decoration: InputDecoration(
                        hintText: "Contract terms here..",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textPaint)),
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
                        errorText:
                            iscrtm == false ? "more than 3 characters" : null),
                    onChanged: (text) {
                      if (text.length < 3) {
                        setState(() {
                          iscrtm = false;
                        });
                      } else {
                        setState(() {
                          iscrtm = true;
                        });
                      }
                    },
                  ),
                ),
                isLoading == false
                    ? Container(
                        margin: EdgeInsets.only(top: 20.0),
                        width: MediaQuery.of(context).size.width / 2,
                        height: 50,
                        color: Colors.blue,
                        child: MaterialButton(
                          child: "Send Contract"
                              .text
                              .white
                              .bold
                              .size((13 / 720) *
                                  MediaQuery.of(context).size.height)
                              .make(),
                          onPressed: iscrtm == true && isjbdp == true
                              ? () async {
                                  isLoading = true;
                                  var result1 = await clientViewModel
                                      .getProviderById(widget.userId);
                                  var result2 = await providerViewModel
                                      .getProviderById(widget.providerId);
                                  contractViewModel
                                      .sendContract(
                                          widget.userId,
                                          widget.providerId,
                                          widget.providerId + widget.userId,
                                          Contracts(
                                              employeeId: widget.providerId,
                                              employerId: widget.userId,
                                              employerName: result1.username!,
                                              employeeName: result2.username,
                                              employerPhoneNumber:
                                                  result1.phoneNumber!,
                                              employeePhoneNumber:
                                                  result2.phoneNumber,
                                              createdAt: DateTime.now(),
                                              jobId: "no id",
                                              jobDescription:
                                                  _jobDescription.text,
                                              jobCategory: result2.occupation,
                                              status: "Pending",
                                              contractTerms:
                                                  _contractTerms.text))
                                      .then((value) {
                                    Navigator.of(context).pop();
                                    isLoading = false;
                                    NotificationHelper().sendMesssage(
                                        result2.token,
                                        "Contract",
                                        '${result1.username} sent a contract. Head to your contract manager to either accept or reject');
                                  });
                                }
                              : null,
                        )).centered().py(30)
                    : Container(
                        height: 50,
                        width: 50,
                        color: Colors.transparent,
                        child: Center(
                            child: CircularProgressIndicator(color: textPaint)))
              ],
            ),
          ),
        ));
  }
}
