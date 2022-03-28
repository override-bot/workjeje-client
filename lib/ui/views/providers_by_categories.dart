import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';

class ProvidersByCategory extends StatefulWidget {
  final String category;
  const ProvidersByCategory({
    required Key key,
    required this.category,
  }) : super(key: key);
  @override
  _ProvidersByCategoryState createState() => _ProvidersByCategoryState();
}

class _ProvidersByCategoryState extends State<ProvidersByCategory> {
  FirebaseQueries firebaseQueries = FirebaseQueries();

  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
          style: TextStyle(
              fontSize: (19 / 720) * MediaQuery.of(context).size.height,
              color: textPaint,
              fontWeight: FontWeight.w600),
        ),
        elevation: 0.0,
        backgroundColor: paint,
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
        width: double.infinity,
        height: double.infinity,
        color: paint,
        child: StreamBuilder(
            stream: firebaseQueries.getProvidersByCategory(widget.category),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  color: paint,
                  child: Center(
                    child: Text(
                        'Oops,\nthere are no Providers in this category yet',
                        style: TextStyle(
                            color: textPaint,
                            fontSize:
                                (18 / 720) * MediaQuery.of(context).size.height,
                            fontWeight: FontWeight.bold)),
                  ),
                );
              }

              return Container();
            }),
      ),
    );
  }
}
