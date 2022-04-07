import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/gallery_model.dart';
import 'package:workjeje/core/viewmodels/providers_view_model.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/viewmodels/gallery_view_model.dart';
import 'image_info.dart';

class ProviderGallery extends StatefulWidget {
  final String uuid;
  ProviderGallery({required this.uuid});
  @override
  _ProviderGalleryState createState() => _ProviderGalleryState();
}

class _ProviderGalleryState extends State<ProviderGallery> {
  List height = [50.0, 20.0, 30.0, 40.0, 60.0];
  Random random = new Random();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? const Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? const Color(0xFFB14181c) : Colors.white;
    final galleryViewModel = Provider.of<GalleryViewModel>(context);
    Color? background =
        isDark == false ? Color.fromARGB(255, 231, 239, 240) : Colors.black26;

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
        body: Container(
            color: background,
            height: double.infinity,
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<List<Gallery>>(
                future: galleryViewModel.getImages(widget.uuid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      color: isDark == true
                          ? const Color(0xFFB14181c)
                          : Colors.white,
                      child: Center(
                        child: Text('Oops,\nNothing to see here',
                            style: TextStyle(
                                color: isDark == false
                                    ? const Color(0xFFB14181c)
                                    : Colors.white,
                                fontSize: (18 / 720) *
                                    MediaQuery.of(context).size.height,
                                fontWeight: FontWeight.bold)),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 7),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: new CachedNetworkImage(
                          imageUrl: snapshot.data![index].imageUrl!,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) =>
                                  CircularProgressIndicator(
                            value: downloadProgress.progress,
                          ),
                          fit: BoxFit.cover,
                          //height: double.infinity,
                          //width: double.infinity,
                          alignment: Alignment.center,
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ImageInformation(
                                  imageUrl: snapshot.data![index].imageUrl!,
                                  imageCaption:
                                      snapshot.data![index].caption!)));
                        },
                      );
                    },
                    itemCount: snapshot.data!.length,
                  );
                })));
  }
  //@override

}
