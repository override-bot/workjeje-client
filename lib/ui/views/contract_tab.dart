import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:workjeje/ui/views/accepted_contract_view.dart';
import 'package:workjeje/ui/views/contract_view.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/authentication.dart';

class ContractTabView extends StatefulWidget {
  @override
  _ContractTabViewState createState() => _ContractTabViewState();
}

class _ContractTabViewState extends State<ContractTabView> {
  User? user = auth.currentUser;
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          elevation: 0.0,
          backgroundColor: paint,
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pending_actions, color: textPaint)),
              Tab(icon: Icon(Icons.check, color: textPaint)),
            ],
            indicatorColor: textPaint,
          ),
          title: isDark == true
              ? "Contract Manager"
                  .text
                  .semiBold
                  .size((20 / 720) * MediaQuery.of(context).size.height)
                  .white
                  .make()
              : "Contract Manager"
                  .text
                  .semiBold
                  .size((20 / 720) * MediaQuery.of(context).size.height)
                  .black
                  .make(),
        ),
        body: TabBarView(children: [ContractView(), FinalizedContracts()]),
      ),
    );
  }
}
