import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/double_mode_implementation/theme_provider.dart';

class JobDescription extends StatefulWidget {
  final String jobDescription;
  final PageController page;
  JobDescription({required this.jobDescription, required this.page});
  JDState createState() => JDState();
}

class JDState extends State<JobDescription> {
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color textPaint = isDark == false ? const Color(0xFFB14181c) : Colors.white;
    return Container(
      child: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 15,
          ),
          Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    widget.page.jumpToPage(0);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: textPaint,
                  ))),
          Container(
            height: 30,
          ),
          Icon(
            Icons.work,
            size: 40,
            color: Colors.blue,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Text(
              'Job Description',
              style: TextStyle(
                  fontSize: (20 / 720) * MediaQuery.of(context).size.height,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              widget.jobDescription,
              style: TextStyle(
                  fontSize: (16 / 720) * MediaQuery.of(context).size.height,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
  }
}
