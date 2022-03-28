// ignore_for_file: prefer_const_constructors

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

  const CustomTextField({
    required this.hintText,
    required this.labelText,
    this.onChanged,
    required this.controller,
    this.errorText,
    this.obscureText,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    //Color paint = isDark == true? Color(0xFFB14181c):Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.only(top: 5.0),
        width: MediaQuery.of(context).size.width / 1.2,
        child: TextFormField(
          onChanged: (text) {
            if (widget.onChanged != null) {
              widget.onChanged!(text);
            }
          },
          controller: widget.controller,
          style: TextStyle(color: textPaint),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: textPaint),
            labelText: widget.labelText,
            labelStyle: TextStyle(
                color: textPaint, fontSize: 20, fontWeight: FontWeight.w600),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: textPaint)),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: textPaint,
            )),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
              color: Colors.red,
            )),
            errorText: widget.errorText,
          ),
          obscureText: widget.obscureText == null ? false : true,
          obscuringCharacter: '*',
        ),
      ),
    );
  }
}
