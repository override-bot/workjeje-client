// ignore_for_file: use_key_in_widget_constructors, use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/double_mode_implementation/theme_provider.dart';

class LoadingButton extends StatefulWidget {
  final String? label;
  final bool? isLoading;
  final Function()? onPressed;
  const LoadingButton(
      {@required this.label,
      @required this.isLoading,
      @required this.onPressed});

  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton> {
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      height: 50,
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 14, 140, 172),
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      child: MaterialButton(
          onPressed: widget.onPressed,
          child: widget.isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.white,
                ))
              : Text(
                  widget.label ?? "",
                  style: GoogleFonts.lato(
                      color: paint,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                )),
    );
  }
}
