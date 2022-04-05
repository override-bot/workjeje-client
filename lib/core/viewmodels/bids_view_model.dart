import 'package:flutter/material.dart';
import 'package:workjeje/core/models/bid_model.dart';
import 'package:workjeje/core/services/subcollection_api.dart';

class BidsViewModel extends ChangeNotifier {
  List<Bid> bids = [];
  Future<List<Bid>> getBids(jobId) async {
    var result = await SubCollectionApi("bids", "jobBid", jobId).getDocuments();
    bids = result.docs
        .map((doc) => Bid.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    //notifyListeners();
    return bids;
  }

  rejectBid(bidId, jobId) {
    SubCollectionApi("bids", "jobBid", jobId).deleteDocument(bidId);
    notifyListeners();
  }
}
