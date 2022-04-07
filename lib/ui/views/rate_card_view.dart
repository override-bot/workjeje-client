import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/rates_model.dart';
import 'package:workjeje/core/viewmodels/rate_card_view_model.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../utils/router.dart';
import '../../utils/stringManip.dart';

class RateCardView extends StatefulWidget {
  final String providerId;
  RateCardView({Key? key, required this.providerId}) : super(key: key);
  @override
  RateCardViewState createState() => RateCardViewState();
}

class RateCardViewState extends State<RateCardView> {
  RouteController routeController = RouteController();
  StringManip stringManip = StringManip();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    ThemeProvider themeProvider = ThemeProvider();
    final rateViewModel = Provider.of<RateCardViewModel>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    IconData darkIcon = isDark == true ? Icons.dark_mode : Icons.light_mode;
    Color? background = isDark == false
        ? Color.fromARGB(255, 237, 241, 241)
        : Color.fromARGB(160, 0, 0, 0);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rates",
          style: TextStyle(
              fontSize: (15 / 720) * MediaQuery.of(context).size.height,
              color: textPaint,
              fontWeight: FontWeight.w600),
        ),
        elevation: 0.0,
        backgroundColor: background,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textPaint,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        color: background,
        child: FutureBuilder<List<Rates>>(
          future: rateViewModel.getRates(widget.providerId),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No service available...yet",
                    style: TextStyle(
                        color: textPaint,
                        fontSize:
                            (22 / 720) * MediaQuery.of(context).size.height),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, index) {
                    return ListTile(
                      title: Text(
                        snapshot.data![index].service!.capitalizeFirstofEach,
                        style: TextStyle(
                            color: textPaint,
                            fontSize: (20 / 720) *
                                MediaQuery.of(context).size.height),
                      ),
                      subtitle: Text(
                        'N${snapshot.data![index].rate!}',
                        style: TextStyle(
                            color: textPaint,
                            fontSize: (18 / 720) *
                                MediaQuery.of(context).size.height),
                      ),
                    );
                  },
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(
                color: textPaint,
              ),
            );
          },
        ),
      ),
    );
  }
}
