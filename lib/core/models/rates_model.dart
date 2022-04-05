class Rates {
  final String? id;
  final String? rate;
  final String? service;
  Rates({this.id, this.service, this.rate});
  Rates.fromMap(Map snapshot, this.id)
      : rate = snapshot['price'],
        service = snapshot['service'];
  toJson() {
    return {"price": rate, "service": service};
  }
}
