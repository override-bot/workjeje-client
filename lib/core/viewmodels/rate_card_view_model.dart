import 'package:flutter/material.dart';
import 'package:workjeje/core/models/rates_model.dart';

import '../services/subcollection_api.dart';

class RateCardViewModel extends ChangeNotifier {
  List<Rates> rates = [];
  Future<List<Rates>> getRates(providerId) async {
    var result =
        await SubCollectionApi("RateCard", "rates", providerId).getDocuments();
    rates = result.docs
        .map((doc) => Rates.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return rates;
  }
}
