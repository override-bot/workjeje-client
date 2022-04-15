// ignore_for_file: unused_import, use_key_in_widget_constructors, prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:workjeje/core/services/authentication.dart';
import 'package:workjeje/ui/shared/shared_button.dart';
import 'package:workjeje/ui/views/client_index.dart';
import 'package:workjeje/ui/views/intro_view.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../utils/router.dart';
import '../shared/custom_textfield.dart';
import '../shared/popup.dart';

class ClientSignUpPage extends StatefulWidget {
  @override
  _ClientSignUpPageState createState() => _ClientSignUpPageState();
}

class _ClientSignUpPageState extends State<ClientSignUpPage> {
  File? _image;
  final picker = ImagePicker();
  List<ImageSource> sources = [ImageSource.camera, ImageSource.gallery];
  Future getImage() async {
    final pickedFile = await picker.getImage(source: sources[1]);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        return;
      }
    });
  }

  Auth auth = Auth();
  RouteController routeController = RouteController();
  PopUp popUp = PopUp();
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  final TextEditingController _locationField = TextEditingController();
  final TextEditingController _fullNameField = TextEditingController();
  final TextEditingController _phoneNumberField = TextEditingController();

  bool isName = true;
  bool isLoading = true;
  bool isNo = true;
  bool isLoc = true;
  bool isPass = true;
  int currentPage = 0;
  final PageController _myPage = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    String link = "assets/wj_final.png";
    return Scaffold(
      body: PageView(
        controller: _myPage,
        onPageChanged: (int _page) {
          currentPage = _page;
        },
        children: [
          Container(
              color: paint,
              child: ListView(children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 3,
                    margin: EdgeInsets.all(10.0),
                    // child: Image.asset(),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.contain, image: AssetImage(link)))),
                Text("Create account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: textPaint))
                    .centered(),
                CustomTextField(
                  controller: _emailField,
                  hintText: "jdoe@gmail.com",
                  labelText: "Email",
                ),
                CustomTextField(
                    controller: _passwordField,
                    obscureText: true,
                    labelText: "Password",
                    hintText: '********',
                    onChanged: (text) {
                      setState(() {
                        if (text.length > 5) {
                          isPass = true;
                        } else {
                          isPass = false;
                        }
                      });
                    },
                    errorText: isPass == false
                        ? "Password should be more than 6 characters"
                        : null),
                CustomTextField(
                    onChanged: (text) {
                      setState(() {
                        if (text.length > 3) {
                          isName = true;
                        } else {
                          isName = false;
                        }
                      });
                    },
                    controller: _fullNameField,
                    hintText: "John Doe",
                    labelText: "Full Name",
                    errorText: isName == false
                        ? "Name should be more than 3 characters"
                        : null),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.0),
                    width: 80,
                    height: 80,
                    color: Colors.transparent,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          _myPage.jumpToPage(1);
                        });
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: textPaint,
                        size: 35,
                      ),
                    ),
                  ),
                )
              ])),
          Container(
            color: paint,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Add a Photo",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: textPaint))
                      .centered(),
                  Container(
                    // padding: EdgeInsets.only(top: 5.0),
                    height: 300,
                    width: 300,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(150),
                        color: Colors.transparent,
                        border: Border.all(color: textPaint)
                        // shape: BoxShape.circle
                        ),
                    child: MaterialButton(
                      elevation: 0.0,
                      onPressed: getImage,
                      child: _image == null
                          ? Icon(Icons.add_a_photo, color: textPaint, size: 40)
                          : Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(_image!)))),
                    ),
                  ).p16(),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.only(top: 20.0),
                          width: 80,
                          height: 80,
                          color: Colors.transparent,
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                _myPage.jumpToPage(0);
                              });
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: textPaint,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 20.0),
                          width: 80,
                          height: 80,
                          color: Colors.transparent,
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                _myPage.jumpToPage(2);
                              });
                            },
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: textPaint,
                              size: 35,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ]),
          ),
          Container(
              color: paint,
              child: ListView(
                children: [
                  Container(
                    height: 80,
                  ),
                  Text("Tell us about you.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: textPaint))
                      .centered(),
                  "Please tell a bit about yourself"
                      .text
                      .gray500
                      .size(22)
                      .bold
                      .center
                      .make(),
                  Container(
                    height: 26,
                  ),
                  CustomTextField(
                      controller: _phoneNumberField,
                      onChanged: (text) {
                        setState(() {
                          if (text.length == 11) {
                            isNo = true;
                          } else {
                            isNo = false;
                          }
                        });
                      },
                      hintText: "07089322045",
                      labelText: "Phone Number",
                      errorText: isNo == false
                          ? "Number should be 11 characters"
                          : null),
                  Container(
                    height: 16,
                  ),
                  Container(
                    height: 16,
                  ),
                  CustomTextField(
                    onChanged: (text) {
                      setState(() {
                        if (text.length > 3) {
                          isLoc = true;
                        } else {
                          isLoc = false;
                        }
                      });
                    },
                    hintText: "Nsukka",
                    labelText: "Location",
                    controller: _locationField,
                    errorText: isLoc == false
                        ? "Location should be more than 3 characters"
                        : null,
                  ),
                  Container(
                    height: 96,
                  ),
                  LoadingButton(
                    label: "Register",
                    onPressed: isName == true &&
                            isLoc == true &&
                            isNo == true &&
                            _image != null
                        ? () {
                            isLoading = true;

                            auth
                                .signUpClient(
                                    _emailField.text,
                                    _passwordField.text,
                                    _locationField.text,
                                    _fullNameField.text,
                                    _image,
                                    _phoneNumberField.text,
                                    context)
                                .then((value) {
                              isLoading = false;

                              routeController
                                  .pushAndRemoveUntil(context, ClientIndex())
                                  .catchError((e) {
                                popUp.showError(e.message, context);
                                isLoading = false;
                              });
                            });
                          }
                        : null,
                    isLoading: null,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
