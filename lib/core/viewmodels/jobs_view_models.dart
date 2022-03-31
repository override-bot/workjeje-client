import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workjeje/core/models/job_model.dart';
import 'package:workjeje/core/services/api.dart';

class JobViewModel extends ChangeNotifier {
  Api jobApi = Api("jobs");
  List<Jobs> jobs = [];
  List<Jobs> clientJobs = [];
  Future<List<Jobs>> getJobs() async {
    var result = await jobApi.getDocuments();
    jobs = result.docs
        .map((doc) => Jobs.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return jobs;
  }

  Future<List<Jobs>> getClientJobs(id) async {
    var result = await jobApi.getWhereIsEqualTo(id, "employerId");
    clientJobs = result.docs
        .map((doc) => Jobs.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return clientJobs;
  }

  Future<Jobs> getJobsById(id) async {
    var doc = await jobApi.getDocumentById(id);
    return Jobs.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

  Stream<QuerySnapshot> streamJobs() {
    return jobApi.streamDocuments();
  }

  Future addJobs(Jobs data) {
    var result = jobApi.addData(data.toJson());
    return result;
  }

  Stream<QuerySnapshot> getUserJobs(userId) {
    return jobApi.queryWhereIsEqualTo(userId, "employerId");
  }
}
