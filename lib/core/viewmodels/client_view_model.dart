import 'package:flutter/material.dart';
import 'package:workjeje/core/services/api.dart';

import '../models/clientmodel.dart';

class ClientViewModel extends ChangeNotifier {
  Api api = Api("clients");
  List<Client> clients = [];

  Future<List<Client>> getProviders() async {
    var result = await api.getDocuments();
    clients = result.docs
        .map(
            (doc) => Client.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return clients;
  }

  Future<Client> getProviderById(id) async {
    var doc = await api.getDocumentById(id);
    return Client.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  deleteClientDetails(id) {
    api.deleteDocument(id);
  }
}
