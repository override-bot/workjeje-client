class Bid {
  final String? id;
  final String providerId;
  dynamic bidAt;
  final String shortMessage;
  Bid(
      {this.id,
      required this.bidAt,
      required this.providerId,
      required this.shortMessage});
  Bid.fromMap(Map snapshot, this.id)
      : bidAt = snapshot['bidAt'],
        providerId = snapshot['employeeId'],
        shortMessage = snapshot['shortMessage'];
  toJson() {
    return {
      "bidAt": bidAt,
      "employeeId": providerId,
      "shortMessage": shortMessage
    };
  }
}
