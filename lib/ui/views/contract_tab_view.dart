// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/ui/views/contract_view.dart';

import '../../core/double_mode_implementation/theme_provider.dart';

class ContractTabView extends StatefulWidget {
  const ContractTabView({Key? key}) : super(key: key);

  @override
  ContractTabViewState createState() => ContractTabViewState();
}

class ContractTabViewState extends State<ContractTabView> {
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    Color? background = isDark == false
        ? Color.fromARGB(255, 237, 241, 241)
        : Color.fromARGB(160, 0, 0, 0);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: background,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pending_actions, color: textPaint)),
              Tab(icon: Icon(Icons.check, color: textPaint)),
            ],
            indicatorColor: textPaint,
          ),
          title: Text(
            "Contracts",
            style: TextStyle(
                color: textPaint,
                fontWeight: FontWeight.w500,
                fontSize: (24 / 720) * MediaQuery.of(context).size.height),
          ),
        ),
        body: TabBarView(children: [ContractView(), Container()]),
      ),
    );
  }
}
