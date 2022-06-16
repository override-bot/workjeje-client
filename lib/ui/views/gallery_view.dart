// ignore_for_file: use_key_in_widget_constructors, use_full_hex_values_for_flutter_colors

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:workjeje/core/models/gallery_model.dart';

import '../../core/double_mode_implementation/theme_provider.dart';
import '../../core/viewmodels/gallery_view_model.dart';
import 'image_info.dart';

class ProviderGallery extends StatefulWidget {
  final String uuid;
  const ProviderGallery({required this.uuid});
  @override
  _ProviderGalleryState createState() => _ProviderGalleryState();
}

class _ProviderGalleryState extends State<ProviderGallery> {
  List height = [50.0, 20.0, 30.0, 40.0, 60.0];
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    final themeStatus = Provider.of<ThemeProvider>(context);
    bool isDark = themeStatus.darkTheme;
    Color paint = isDark == true ? const Color(0xFFB14181c) : Colors.white;
    Color textPaint = isDark == false ? const Color(0xFFB14181c) : Colors.white;
    final galleryViewModel = Provider.of<GalleryViewModel>(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          // centerTitle: true,
          titleSpacing: 5,
          title: Text(
            "Gallery",
            style: TextStyle(
                color: textPaint,
                fontWeight: FontWeight.w500,
                fontSize: (15 / 720) * MediaQuery.of(context).size.height),
          ),
          backgroundColor: paint,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: textPaint,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
        body: Container(
            color: paint,
            height: double.infinity,
            padding: const EdgeInsets.all(5),
            child: FutureBuilder<List<Gallery>>(
                future: galleryViewModel.getImages(widget.uuid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
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

                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Stack(children: [
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                        snapshot.data![index].imageUrl![0],
                                      )))),
                          snapshot.data![index].imageUrl!.length > 1
                              ? Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Icon(
                                    Icons.collections,
                                    color: Colors.white,
                                  ),
                                )
                              : Container()
                        ]),
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
                    staggeredTileBuilder: (int index) {
                      return StaggeredTile.count(2, index.isEven ? 3 : 4);
                    },
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  );
                })));
  }
  //@override

}
