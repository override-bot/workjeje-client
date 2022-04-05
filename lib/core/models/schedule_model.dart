class Schedule {
  final String? id;
  final String? activity;
  dynamic date;
  dynamic startTime;
  dynamic endTime;
  Schedule({this.activity, this.date, this.endTime, this.id, this.startTime});
  Schedule.fromMap(Map snapshot, this.id)
      : activity = snapshot['activity'],
        date = snapshot['date'],
        endTime = snapshot['endTime'],
        startTime = snapshot['startTime'];
  toJson() {
    return {
      "activity": activity,
      "date": date,
      "endTime": endTime,
      "startTime": startTime
    };
  }
}
