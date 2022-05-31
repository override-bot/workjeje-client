import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workjeje/core/services/authentication.dart';
import 'package:workjeje/ui/shared/custom_textfield.dart';
import 'package:workjeje/ui/shared/popup.dart';
import 'package:workjeje/ui/shared/shared_button.dart';

class GetStarted extends StatefulWidget {
  @override
  GetStartedState createState() => GetStartedState();
}

class GetStartedState extends State<GetStarted> {
  String link = "assets/wj_final.png";
  bool? isLoading = false;
  Color blue = Color.fromARGB(255, 14, 140, 172);
  TextEditingController _phoneField = TextEditingController();
  Auth _auth = Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Colors.grey[100],
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(left: 10),
                  // child: Image.asset(),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain, image: AssetImage(link)))),
              Container(
                  margin: EdgeInsets.only(left: 20.0, top: 10),
                  child: Text("Sign up",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize:
                              30 / 720 * MediaQuery.of(context).size.height,
                          color: Color.fromARGB(255, 14, 140, 172)))),
              Container(
                  margin: EdgeInsets.only(left: 20.0, top: 7),
                  child: Text("to get started",
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700,
                          fontSize:
                              25 / 720 * MediaQuery.of(context).size.height,
                          color: Colors.grey))),
              Container(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: CustomTextField(
                    hintText: "07012345678",
                    labelText: "Your phone number",
                    controller: _phoneField),
              ),
              Container(
                height: 30,
              ),
              Container(
                  margin: EdgeInsets.only(top: 30, left: 20),
                  height: 70,
                  width: 200,
                  color: blue,
                  child: isLoading == false
                      ? MaterialButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });

                            await _auth
                                .verifyNumber(_phoneField.text.trim(), context)
                                .whenComplete(() {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          },
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))),
            ],
          ),
        ),
      ),
    );
  }
}
