// ignore_for_file: use_key_in_widget_constructors, use_full_hex_values_for_flutter_colors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
//import 'package:workman/double_mode_implementation/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../core/double_mode_implementation/theme_provider.dart';

class ImageInformation extends StatefulWidget {
  // String photoId;
  final List imageUrl;
  final String imageCaption;
  const ImageInformation({required this.imageUrl, required this.imageCaption});
  @override
  ImageInfoState createState() => ImageInfoState();
}

class ImageInfoState extends State<ImageInformation> {
  Future popLoad(caption, context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                color: Colors.transparent,
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                width: MediaQuery.of(context).size.width / 1.2,
                //height: 100,
                child: Text(
                  caption ?? "No caption",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: (15 / 720) * MediaQuery.of(context).size.height,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("dismiss",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600)))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color? background = isDark == false
        ? const Color.fromARGB(255, 231, 239, 240)
        : Colors.black26;

    Color textPaint = isDark == false ? const Color(0xFFB14181c) : Colors.white;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: textPaint,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children:
                    List<Widget>.generate(widget.imageUrl.length, (index) {
              return GestureDetector(
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.05,
                  child: new CachedNetworkImage(
                    imageUrl: widget.imageUrl[index],
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    ).shimmer(),
                    //fit: BoxFit.cover,
                    //height: double.infinity,
                    //width: double.infinity,
                    alignment: Alignment.center,
                  ),
                ).centered(),
                onTap: () {
                  popLoad(widget.imageCaption, context);
                },
              );
            }))));
  }
}
