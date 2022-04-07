import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
//import 'package:workman/double_mode_implementation/theme_provider.dart';
import 'package:flutter/material.dart';

import '../../core/double_mode_implementation/theme_provider.dart';

class ImageInformation extends StatefulWidget {
  // String photoId;
  final String imageUrl;
  final String imageCaption;
  ImageInformation({required this.imageUrl, required this.imageCaption});
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
                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                  child: Text("dismiss",
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
    Color? background =
        isDark == false ? Color.fromARGB(255, 231, 239, 240) : Colors.black26;

    Color paint = isDark == true ? Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? Color(0xFFB14181c) : Colors.white;
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: background,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: textPaint,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: GestureDetector(
          child: Container(
            color: background,
            height: double.infinity,
            width: double.infinity,
            child: new CachedNetworkImage(
              imageUrl: widget.imageUrl,
              errorWidget: (context, url, error) => Icon(Icons.error),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(
                value: downloadProgress.progress,
              ),
              fit: BoxFit.fitWidth,
              //height: double.infinity,
              //width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          onTap: () {
            popLoad(widget.imageCaption, context);
          },
        ));
  }
}
