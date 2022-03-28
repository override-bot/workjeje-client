import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/ui/views/subcategories.dart';
import 'package:workjeje/utils/router.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/services/queries.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  FirebaseQueries firebaseQueries = FirebaseQueries();
  List categories = [];
  List images = [];
  String category = "";
  RouteController routeController = RouteController();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: paint,
          elevation: 0.0,
          title: Text(
            "Categories",
            style: TextStyle(
                color: textPaint,
                fontWeight: FontWeight.w500,
                fontSize: (24 / 720) * MediaQuery.of(context).size.height),
          ),
        ),
        body: Container(
            color: paint,
            height: double.infinity,
            width: double.infinity,
            child: FutureBuilder<DocumentSnapshot>(
                future: firebaseQueries.getCategoryDoc(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    categories = data['Category'];
                    images = data['Images'];
                    return StaggeredGridView.countBuilder(
                      crossAxisCount: 4,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                            onTap: () {
                              routeController.push(
                                  context,
                                  Subcategories(
                                      category: data['Category'][index]));
                            },
                            child: CachedNetworkImage(
                                imageUrl: images[index],
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                progressIndicatorBuilder: (context, url,
                                        downloadProgress) =>
                                    Container(
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                            child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                        ))),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.black12,
                                                BlendMode.colorBurn),
                                          )),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          categories[index],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              // backgroundColor: Colors.black87,
                                              fontSize: (17 / 720) *
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height),
                                        ),
                                      ),
                                    )));
                      },
                      staggeredTileBuilder: (int index) {
                        return StaggeredTile.count(2, index.isEven ? 2 : 2);
                      },
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                    );
                  } else {
                    return Container();
                  }
                })));
  }
}
