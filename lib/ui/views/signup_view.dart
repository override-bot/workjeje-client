// ignore_for_file: unused_import, use_key_in_widget_constructors, prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:workjeje/core/models/clientmodel.dart';
import 'package:workjeje/core/services/authentication.dart';
import 'package:workjeje/core/services/location.dart';
import 'package:workjeje/core/services/notification_helper.dart';
import 'package:workjeje/core/services/storage.dart';
import 'package:workjeje/ui/shared/shared_button.dart';
import 'package:workjeje/ui/views/client_index.dart';
import 'package:workjeje/ui/views/intro_view.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/viewmodels/client_view_model.dart';
import '../../utils/router.dart';
import '../shared/custom_textfield.dart';
import '../shared/popup.dart';

class ClientSignUpPage extends StatefulWidget {
  final String? phoneNumber;
  final String? uid;
  ClientSignUpPage({this.phoneNumber, this.uid});
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
  Storage _storage = Storage();
  final TextEditingController _locationField = TextEditingController();
  final TextEditingController _fullNameField = TextEditingController();
  final TextEditingController _phoneNumberField = TextEditingController();

  bool? isName;
  bool isLoading = false;

  bool? isEmail;

  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    final location = Provider.of<LocationService>(context);
    final clientViewModel = Provider.of<ClientViewModel>(context);
    final notificationHelper = Provider.of<NotificationHelper>(context);
    _locationField.text = location.location!;
    _phoneNumberField.text = widget.phoneNumber!;
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    String link = "assets/wj_final.png";
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          height: double.infinity,
          color: Colors.grey[100],
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Container(
                    margin: EdgeInsets.only(left: 20.0, top: 20),
                    child: Text("Hello!\nSignup to\nget started",
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize:
                                22 / 720 * MediaQuery.of(context).size.height,
                            color: Color.fromARGB(255, 14, 140, 172)))),
                Container(
                    // padding: EdgeInsets.only(top: 5.0),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        border: Border.all(
                            width: 2, color: Color.fromARGB(255, 14, 140, 172))
                        // shape: BoxShape.circle
                        ),
                    child: Stack(clipBehavior: Clip.none, children: [
                      Positioned(
                        child: Icon(
                          Icons.camera_alt,
                          color: Color.fromARGB(255, 14, 140, 172),
                        ),
                        bottom: -10,
                        right: -8,
                      ),
                      MaterialButton(
                        elevation: 0.0,
                        onPressed: getImage,
                        child: _image == null
                            ? CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/IMG_4446.PNG"),
                                radius: 80,
                              )
                            : CircleAvatar(
                                backgroundImage: FileImage(_image!),
                                radius: 70,
                              ),
                      ),
                    ])).p16(),
                _image == null
                    ? Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Text(
                          "*profile picture is required",
                          style: TextStyle(color: Colors.red),
                        ))
                    : Container(),
                CustomTextField(
                    controller: _emailField,
                    hintText: "jdoe@gmail.com",
                    labelText: "Email",
                    onChanged: (text) {
                      if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(text)) {
                        setState(() {
                          isEmail = true;
                        });
                      } else {
                        setState(() {
                          isEmail = false;
                        });
                      }
                    },
                    errorText: isEmail == false ? "enter a valid email" : null),
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
                CustomTextField(
                  controller: _phoneNumberField,
                  isEnabled: false,
                  hintText: "07089322045",
                  labelText: "Phone Number",
                ),
                CustomTextField(
                  hintText: "Nsukka",
                  labelText: "Location",
                  isEnabled: false,
                  controller: _locationField,
                ),
                LoadingButton(
                        label: "Register",
                        isLoading: isLoading,
                        onPressed: isName == true &&
                                _image != null &&
                                isEmail == true
                            ? () async {
                                setState(() {
                                  isLoading = true;
                                });
                                String displayPictureUrl = await _storage
                                    .uploadImage(_image, widget.uid);
                                clientViewModel
                                    .addClient(
                                        Client(
                                            email: _emailField.text,
                                            phoneNumber: _phoneNumberField.text,
                                            location: _locationField.text,
                                            token: notificationHelper.token,
                                            username: _fullNameField.text,
                                            imageurl: displayPictureUrl),
                                        widget.uid)
                                    .then((value) {
                                  routeController.pushAndRemoveUntil(
                                      context, ClientIndex());
                                });
                              }
                            : null)
                    .centered()
              ]))),
    );
  }
}
