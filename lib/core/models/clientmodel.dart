class Client {
  final String? id;
  final String? username;
  final String? location;
  final String? phoneNumber;
  final String? imageurl;
  dynamic userLat;
  dynamic userLong;
  final String? email;
  Client(
      {this.email,
      this.id,
      this.imageurl,
      this.location,
      this.phoneNumber,
      this.userLat,
      this.userLong,
      this.username});
  Client.fromMap(Map snapshot, this.id)
      : email = snapshot['email'],
        imageurl = snapshot['imageurl'],
        location = snapshot['location'],
        phoneNumber = snapshot['phoneNumber'],
        userLat = snapshot['userLat'],
        userLong = snapshot['userLong'],
        username = snapshot['username'];
  toJson() {
    return {
      "username": username,
      "userLat": userLat,
      "userLong": userLong,
      "location": location,
      "email": email,
      "phoneNumber": phoneNumber,
      "imageurl": imageurl
    };
  }
}
