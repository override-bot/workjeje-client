class Jobs {
  final String? id;
  final String employerId;
  final String jobDescription;
  final String username;
  final String location;
  final String jobCategory;
  final String phoneNumber;
  final String email;
  dynamic addedAt;
  Jobs(
      {this.id,
      required this.employerId,
      required this.addedAt,
      required this.email,
      required this.jobCategory,
      required this.jobDescription,
      required this.location,
      required this.phoneNumber,
      required this.username});
  Jobs.fromMap(Map snapshot, this.id)
      : employerId = snapshot['employerId'],
        jobDescription = snapshot['jobDescription'],
        username = snapshot['username'],
        location = snapshot['location'],
        jobCategory = snapshot['jobCategory'],
        phoneNumber = snapshot['phoneNumber'],
        email = snapshot['email'],
        addedAt = snapshot['addedAt'];
  toJson() {
    return {
      "employerId": employerId,
      "jobDescription": jobDescription,
      "username": username,
      "location": location,
      "jobCategory": jobCategory,
      "phoneNumber": phoneNumber,
      "email": email,
      "addedAt": addedAt
    };
  }
}
