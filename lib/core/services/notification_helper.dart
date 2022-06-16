import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'authentication.dart';

class NotificationHelper {
  String? token;
  Future sendMesssage(token, title, message) async {
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    // ignore: unused_local_variable
    var res = await func.call(<String, dynamic>{
      "targetDevices": token,
      "messageTitle": title,
      "messageBody": message
    });
  }

  updateToken(token) {
    final User? user = auth.currentUser;
    if (user?.uid != null) {
      if (token != null) {
        FirebaseFirestore.instance
            .collection("clients")
            .doc(user?.uid)
            .update({"token": token});
        print("$token updated");
      } else {
        FirebaseFirestore.instance
            .collection("clients")
            .doc(user?.uid)
            .update({"token": "no token"});
      }
    } else {
      return;
    }
  }
}
