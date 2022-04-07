import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import "package:geocoding/geocoding.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workjeje/core/services/queries.dart';

class LocationService extends ChangeNotifier {
  double? userLat;
  double? userLong;
  getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    userLat = position.latitude;
    notifyListeners();
    userLong = position.longitude;
    notifyListeners();
  }

  updatePosition(role, userId) {
    if (userId != null) {
      Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.best,
      ).listen((Position position) async {
        print(position);

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
