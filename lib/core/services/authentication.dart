import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workjeje/core/services/location.dart';
import 'package:workjeje/core/services/messaging_service.dart';
import 'package:workjeje/core/services/storage.dart';
import 'package:workjeje/core/viewmodels/client_view_model.dart';
import 'package:workjeje/ui/shared/popup.dart';
import 'package:workjeje/ui/views/client_index.dart';
import 'package:workjeje/ui/views/signup_view.dart';
import 'package:workjeje/utils/router.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
MessagingService _messagingService = MessagingService();
ClientViewModel _clientViewModel = ClientViewModel();
RouteController _route = RouteController();
PopUp _popUp = PopUp();

class Auth {
  Future checkIfUser(userId, context, phoneNumber) async {
    var res = await _clientViewModel.getUserbyId(userId);
    if (res == null) {
      print(userId);
      _route.pushAndRemoveUntil(
          context,
          ClientSignUpPage(
            phoneNumber: phoneNumber,
            uid: userId,
          ));
    } else {
      _route.pushAndRemoveUntil(context, ClientIndex());
    }
  }

  Future checkIfUseri(userId, context, phoneNumber) async {
    var res = await _clientViewModel.getUserbyId(userId);
    if (res == null) {
      print(userId);
      _route.pushAndRemoveUntil(
          context,
          ClientSignUpPage(
            phoneNumber: phoneNumber,
            uid: userId,
          ));
    }
  }

  Future verifyNumber(phoneNumber, context) async {
    return auth.verifyPhoneNumber(
        phoneNumber: '+234$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {
          var user = await auth.signInWithCredential(credential);
          checkIfUser(user.user?.uid, context, phoneNumber);
        },
        verificationFailed: (authException) {
          _popUp.showError(authException.message, context);
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          Color blue = Color.fromARGB(255, 14, 140, 172);
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Container(
                      width: MediaQuery.of(context).size.width / 1,
                      margin: EdgeInsets.all(3),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text("Verification code",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15 /
                                        720 *
                                        MediaQuery.of(context).size.height,
                                    color: Color.fromARGB(255, 14, 140, 172)))),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                                "Enter the verification code sent to you",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13 /
                                        720 *
                                        MediaQuery.of(context).size.height,
                                    color: Colors.grey))),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: OtpTextField(
                            fieldWidth: 35,
                            numberOfFields: 6,
                            showFieldAsBox: true,
                            focusedBorderColor: blue,
                            onSubmit: (String code) async {
                              _popUp.popLoad(context);
                              try {
                                var smsCode = code;
                                var credential =
                                    await PhoneAuthProvider.credential(
                                        verificationId: verificationId,
                                        smsCode: smsCode);
                                var user =
                                    await auth.signInWithCredential(credential);
                                checkIfUser(
                                    user.user?.uid, context, phoneNumber);
                              } on FirebaseAuthException catch (e) {
                                _route.pop(context);
                                _popUp.showError(e.code, context);
                              }
                            },
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text("This helps us verify every user",
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13 /
                                        720 *
                                        MediaQuery.of(context).size.height,
                                    color: Colors.grey[500]))),
                        GestureDetector(
                          onTap: () {
                            verifyNumber(phoneNumber, context);
                          },
                          child: Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text("Didn't get the code?",
                                  style: GoogleFonts.lato(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13 /
                                          720 *
                                          MediaQuery.of(context).size.height,
                                      color:
                                          Color.fromARGB(255, 14, 140, 172)))),
                        )
                      ])),
                );
              });
        },
        codeAutoRetrievalTimeout: (verificationId) {});
  }

  Future signOut() async {
    await auth.signOut();
  }

  Future deleteAccount() async {
    await auth.currentUser?.delete();
  }

  bool authState() {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }
    return true;
  }
}
