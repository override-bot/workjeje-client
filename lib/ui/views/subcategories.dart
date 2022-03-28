import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';

class Subcategories extends StatefulWidget {
  final String? category;
  const Subcategories({this.category});

  @override
  _SubcategoriesState createState() => _SubcategoriesState();
}

class _SubcategoriesState extends State<Subcategories> {
  List subcategories = [];
  Random random = new Random();
  List<IconData> icons = [Icons.work, Icons.category, Icons.construction];
  FirebaseQueries firebaseQueries = FirebaseQueries();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: paint,
          centerTitle: true,
          title: Text(widget.category!,
              style: TextStyle(
                  color: textPaint,
                  fontSize: (19 / 720) * MediaQuery.of(context).size.height)),
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
            width: double.infinity,
            color: paint,
            child: FutureBuilder<DocumentSnapshot>(
                future: firebaseQueries.getCategoryDoc(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    subcategories = data[widget.category];
                    return ListView.builder(
                        itemCount: subcategories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.only(top: 12),
                              child: ListTile(
                                leading: Icon(icons[random.nextInt(3)],
                                    color: textPaint),
                                title: Text(
                                  subcategories[index],
                                  style: TextStyle(
                                      fontSize: (15 / 720) *
                                          MediaQuery.of(context).size.height,
                                      fontWeight: FontWeight.w600,
                                      color: textPaint),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: textPaint),
                              ));
                        });
                  } else {
                    return Center(
                      child: Container(
                          child: CircularProgressIndicator(
                        color: textPaint,
                      )),
                    );
                  }
                })));
  }
}
