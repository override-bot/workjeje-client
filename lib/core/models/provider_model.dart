class ServiceProvider {
  final String? id;
  final String username;
  final String occupation;
  final List skill;
  final String location;
  final String phoneNumber;
  final String imageurl;
  final String verificationStatus;
  final String onlineStatus;
  dynamic lastSeen;
  final int rating;
  final int raters;
  final String email;
  final double userLat;
  final double userLong;
  ServiceProvider({
    this.id,
    required this.username,
    required this.occupation,
    required this.skill,
    required this.location,
    required this.phoneNumber,
    required this.imageurl,
    required this.verificationStatus,
    required this.onlineStatus,
    required this.lastSeen,
    required this.rating,
    required this.raters,
    required this.email,
    required this.userLat,
    required this.userLong,
  });
  ServiceProvider.fromMap(Map snapshot, this.id)
      : username = snapshot['username'],
        occupation = snapshot['occupation'],
        skill = snapshot['skill'],
        location = snapshot['location'],
        phoneNumber = snapshot['phoneNumber'],
        imageurl = snapshot['imageurl'],
        verificationStatus = snapshot['verificationStatus'],
        onlineStatus = snapshot['onlineStatus'],
        lastSeen = snapshot['lastSeen'],
        rating = snapshot['rating'],
        raters = snapshot['raters'],
        email = snapshot['email'],
        userLat = snapshot['userLat'],
        userLong = snapshot['userLong'];
  toJson() {
    return {
      "username": username,
      "userLat": userLat,
      "userLong": userLong,
      "occupation": occupation,
      "skill": skill,
      "location": location,
      "email": email,
      "phoneNumber": phoneNumber,
      "imageurl": imageurl,
      "rating": rating,
      "raters": raters,
      "verificationStatus": verificationStatus,
      "onlineStatus": onlineStatus,
    };
  }
}
