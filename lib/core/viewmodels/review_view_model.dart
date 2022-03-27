import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workjeje/core/models/review_model.dart';
import 'package:workjeje/core/services/subcollection_api.dart';

class ReviewViewModel extends ChangeNotifier {
  Stream<QuerySnapshot> streamReviews(userId) {
    return SubCollectionApi("reviews", "userReviews", userId).streamDocuments();
  }

  Future rateProvider(Reviews data, userId) {
    return SubCollectionApi("reviews", "userReviews", userId)
        .addData(data.toJson());
  }
}
