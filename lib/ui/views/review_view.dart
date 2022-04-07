import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/viewmodels/review_view_model.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';
import '../../utils/router.dart';

class ReviewWidget extends StatefulWidget {
  final String uid;
  ReviewWidget({required this.uid});
  @override
  ReviewWidgetState createState() => ReviewWidgetState();
}

class ReviewWidgetState extends State<ReviewWidget> {
  RouteController routeController = RouteController();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    final reviewViewModel = Provider.of<ReviewViewModel>(context);
    bool isDark = themeStatus.darkTheme;
    //  Color paint = isDark == true? Color(0xFFB14181c):Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    Color? background =
        isDark == false ? Color.fromARGB(255, 231, 239, 240) : Colors.black26;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: Text(
            "Reviews",
            style: TextStyle(
                fontSize: (15 / 720) * MediaQuery.of(context).size.height,
                color: textPaint,
                fontWeight: FontWeight.w600),
          ),
          backgroundColor: background,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: textPaint,
            ),
            onPressed: () {
              routeController.pop(context);
            },
          ),
        ),
        body: Container(
            // color: Colors.black87,
            height: double.infinity,
            color: background,
            child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                    stream: reviewViewModel.streamReviews(widget.uid),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                            children: snapshot.data!.docs.map<Widget>(
                                (DocumentSnapshot<Map<String, dynamic>>
                                    document) {
                          return Container(
                              color: Colors.transparent,
                              margin: EdgeInsets.only(top: 0),
                              width: MediaQuery.of(context).size.width / 1,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Divider(),
                                    Divider(
                                      color: textPaint,
                                    ),
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            document.data()!['image']),
                                      ),
                                      title: Text(
                                        document.data()!['name'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: textPaint),
                                      ),
                                      subtitle: Container(
                                        height: 20,
                                        child: RatingBarIndicator(
                                          rating: document.data()!['rate'] / 1,
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 20,
                                          direction: Axis.horizontal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 30),
                                      child: Text(
                                        document.data()!['review'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: textPaint),
                                      ),
                                    ),
                                    Container(height: 4),
                                  ]));
                        }).toList());
                      } else {
                        return Container();
                      }
                    }))));
  }
}
