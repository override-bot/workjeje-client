import 'package:flutter/material.dart';
import 'package:workjeje/core/models/schedule_model.dart';

import '../services/subcollection_api.dart';

class ScheduleViewModel extends ChangeNotifier {
  List<Schedule> schedule = [];
  Future<List<Schedule>> getSchedule(providerId) async {
    var result = await SubCollectionApi("userSchedule", "schedule", providerId)
        .getDocuments();
    schedule = result.docs
        .map((doc) =>
            Schedule.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    return schedule;
  }
}
