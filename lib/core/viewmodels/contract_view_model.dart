import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workjeje/core/models/contract_model.dart';
import 'package:workjeje/core/services/api.dart';
import 'package:workjeje/core/services/subcollection_api.dart';
import 'package:workjeje/core/viewmodels/providers_view_model.dart';

class ContractViewModel extends ChangeNotifier {
  List<Contracts> contracts = [];
  List<Contracts> accepted = [];
  Future<List<Contracts>> getContracts(userId) async {
    var result = await SubCollectionApi("contracts", "userContracts", userId)
        .getWhereIsNotEqualTo("Completed", "Status");
    contracts = result.docs
        .map((doc) =>
            Contracts.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return contracts;
  }

  Future<Contracts> getContractsByID(id, userId) async {
    var doc = await SubCollectionApi("contracts", "userContracts", userId)
        .getDocumentById(id);
    return Contracts.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  cancelContract(id, userId, providerId) {
    SubCollectionApi("contracts", "userContracts", userId).deleteDocument(id);
    SubCollectionApi("contracts", "userContracts", providerId)
        .deleteDocument(id);
  }

  Stream<QuerySnapshot> streamAcceptedContracts(userId) {
    return SubCollectionApi("contracts", "userContracts", userId)
        .queryWhereIsEqualTo("Accepted", "Status");
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAcceptedContracts(userId) {
    Query<Map<String, dynamic>> acceptedContracts;
    acceptedContracts = FirebaseFirestore.instance
        .collection("contracts")
        .doc(userId)
        .collection("userContracts")
        .where('Status', isEqualTo: "Accepted");
    return acceptedContracts.snapshots();
  }

  Stream<QuerySnapshot> streamContracts(userId) {
    return SubCollectionApi("contracts", "userContracts", userId)
        .streamDocuments();
  }

  Stream<DocumentSnapshot> streamContractDetails(userId, docId) {
    return SubCollectionApi("contracts", "userContracts", userId)
        .streamDocumentById(docId);
  }

  Future completeContract(userId, docId, providerId) async {
    var result = await ProviderViewModel().getProviderById(providerId);
    var completedJobs = result.jobs;
    Api("providers").updateDocument("jobs", completedJobs + 1, providerId);
    return SubCollectionApi("contracts", "userContracts", userId)
        .updateDocument("Status", "Completed", docId)
        .then((value) {
      SubCollectionApi("contracts", "userContracts", providerId)
          .updateDocument("Status", "Completed", docId);
      notifyListeners();
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
