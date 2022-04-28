import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import "package:geocoding/geocoding.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService extends ChangeNotifier {
  double? userLat;
  double? userLong;
  String? location;
  Future<Position> getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return position;
  }

  updatePosition(role, userId) {
    if (userId != null) {
      Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
      ).listen((Position position) async {
        if (kDebugMode) {
          print(position);
        }

        List<Placemark> addresses = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        var first = addresses.first;
        FirebaseFirestore.instance.collection(role).doc(userId).update({
          "userLat": position.latitude,
          "userLong": position.longitude,
          "location": first.locality
        });
      });
    } else {
      return;
    }
  }
}
