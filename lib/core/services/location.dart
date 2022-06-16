import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import "package:geocoding/geocoding.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService extends ChangeNotifier {
  double? userLat;
  double? userLong;
  String? location;
  Future getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    return position;
  }

  Future<LocationPermission> getPerm() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission;
  }

  updatePosition(role, userId) async {
    LocationPermission perm = await getPerm();
    if (perm == LocationPermission.always ||
        perm == LocationPermission.whileInUse) {
      Position position = await getPosition();
      List<Placemark> addresses =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      var first = addresses.first;
      FirebaseFirestore.instance.collection(role).doc(userId).update({
        "userLat": position.latitude,
        "userLong": position.longitude,
        "location": first.locality
      });
    }
  }
}
