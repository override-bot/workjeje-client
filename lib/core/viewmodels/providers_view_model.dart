import 'package:flutter/material.dart';
import 'package:workjeje/core/models/provider_model.dart';
import 'package:workjeje/core/services/api.dart';

class ProviderViewModel extends ChangeNotifier {
  Api api = Api("providers");
  List<ServiceProvider> providers = [];
  List<ServiceProvider> categoryProviders = [];
  Future<List<ServiceProvider>> getProviders() async {
    var result = await api.getDocuments();
    providers = result.docs
        .map((doc) =>
            ServiceProvider.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return providers;
  }

  Future<ServiceProvider> getProviderById(id) async {
    var doc = await api.getDocumentById(id);
    return ServiceProvider.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Future<List<ServiceProvider>> streamProvidersByCategories(category) async {
    var result = await api.queryWhereArrayContains(category, "skill");
    categoryProviders = result.docs
        .map((doc) =>
            ServiceProvider.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return categoryProviders;
  }

  Future rateProvider(providerId, rate) async {
    var result = await getProviderById(providerId);
    var oldRate = result.rating;
    var oldRaters = result.raters;
    api.updateDocument("rating", oldRate + rate, providerId);
    api.updateDocument("raters", oldRaters + 1, providerId);
  }
}
