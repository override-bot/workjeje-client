// ignore_for_file: prefer_const_constructors

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../core/double_mode_implementation/theme_provider.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final Function? onChanged;
  final TextEditingController controller;
  final String? errorText;
  final bool? obscureText;
  final bool? isEnabled;

  // ignore: use_key_in_widget_constructors
  const CustomTextField(
      {required this.hintText,
      required this.labelText,
      this.onChanged,
      required this.controller,
      this.errorText,
      this.obscureText,
      this.isEnabled});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    //Color paint = isDark == true? Color(0xFFB14181c):Colors.white;
    // ignore: use_full_hex_values_for_flutter_colors
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.only(top: 5.0),
        width: MediaQuery.of(context).size.width / 1.1,
        child: TextFormField(
          onChanged: (text) {
            if (widget.onChanged != null) {
              widget.onChanged!(text);
            }
          },
          controller: widget.controller,
          style: TextStyle(color: Colors.black),
          enabled: widget.isEnabled,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey),
            labelText: widget.labelText,
            labelStyle: GoogleFonts.lato(
                color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w500),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              width: 2.5,
              color: Color.fromARGB(255, 14, 140, 172),
            )),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
              width: 2,
              color: Colors.grey,
            )),
            errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 2)),
            errorText: widget.errorText,
          ),
          obscureText: widget.obscureText == null ? false : true,
          obscuringCharacter: '*',
        ),
      ),
    );
  }
}
