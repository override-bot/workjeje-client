import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/double_mode_implementation/theme_provider.dart';

class ContractTerms extends StatefulWidget {
  final PageController page;
  final String contractTerms;
  ContractTerms({required this.contractTerms, required this.page});
  ContractTermsState createState() => ContractTermsState();
}

class ContractTermsState extends State<ContractTerms> {
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color textPaint = isDark == false ? const Color(0xFFB14181c) : Colors.white;
    return Container(
      child: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
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
            Icons.pending_actions,
            size: 30,
            color: Colors.blue,
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: Text(
              'Contract Terms',
              style: TextStyle(
                  fontSize: (20 / 720) * MediaQuery.of(context).size.height,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              widget.contractTerms,
              style: TextStyle(
                  fontSize: (16 / 720) * MediaQuery.of(context).size.height,
                  color: Colors.black,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
