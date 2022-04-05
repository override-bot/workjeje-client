import 'package:flutter/material.dart';
import 'package:workjeje/core/models/gallery_model.dart';

import '../services/subcollection_api.dart';

class GalleryViewModel extends ChangeNotifier {
  List<Gallery> images = [];
  Future<List<Gallery>> getImages(providerId) async {
    var result = await SubCollectionApi("UserGallery", "images", providerId)
        .getDocuments();
    images = result.docs
        .map((doc) =>
            Gallery.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return images;
  }
}
