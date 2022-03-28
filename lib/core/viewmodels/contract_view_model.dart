import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workjeje/core/models/contract_model.dart';
import 'package:workjeje/core/services/subcollection_api.dart';

class ContractViewModel extends ChangeNotifier {
  List<Contracts> contracts = [];
  Future<List<Contracts>> getContracts(userId) async {
    var result = await SubCollectionApi("contracts", "userContracts", userId)
        .getDocuments();
    contracts = result.docs
        .map((doc) =>
            Contracts.fromMap(doc.data as Map<String, dynamic>, doc.id))
        .toList();
    return contracts;
  }

  Future<Contracts> getContractsByID(id, userId) async {
    var doc = await SubCollectionApi("contracts", "userContracts", userId)
        .getDocumentById(id);
    return Contracts.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Stream<QuerySnapshot> streamAcceptedContracts(userId) {
    return SubCollectionApi("contracts", "userContracts", userId)
        .queryWhereIsEqualTo("Accepted", "Status");
  }

  Stream<QuerySnapshot> streamContracts(userId) {
    return SubCollectionApi("contracts", "userContracts", userId)
        .streamDocuments();
  }

  Stream<DocumentSnapshot> streamContractDetails(userId, docId) {
    return SubCollectionApi("contracts", "userContracts", userId)
        .streamDocumentById(docId);
  }

  Future completeContract(userId, docId, providerId) {
    return SubCollectionApi("contracts", "userContracts", userId)
        .updateDocument("Status", "Completed", docId)
        .then((value) {
      SubCollectionApi("contracts", "userContracts", providerId)
          .updateDocument("Status", "Completed", docId);
    });
  }

  Stream<QuerySnapshot> getCompletedContracts(userId) {
    return SubCollectionApi("contracts", "userContracts", userId)
        .queryWhereIsEqualTo("Completed", "Status");
  }

  Future sendContract(userId, providerId, id, Contracts data) {
    return SubCollectionApi("contracts", "userContracts", userId)
        .setData(id, data.toJson())
        .then((value) {
      SubCollectionApi("contracts", "userContracts", providerId)
          .setData(id, data.toJson());
    });
  }
}
