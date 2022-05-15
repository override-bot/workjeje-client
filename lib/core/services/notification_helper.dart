import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'queries.dart';

class NotificationHelper {
  Future sendMesssage(token, title, message) async {
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    var res = await func.call(<String, dynamic>{
      "targetDevices": token,
      "messageTitle": title,
      "messageBody": message
    });
  }

  updateToken(token) {
    if (user?.uid != null) {
      FirebaseFirestore.instance
          .collection("clients")
          .doc(user?.uid)
          .update({"token": token});
    } else {
      return;
    }
  }
}
