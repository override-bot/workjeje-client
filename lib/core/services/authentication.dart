import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:workjeje/core/services/storage.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class Auth {
  Storage storage = Storage();
  Future<User?> signUpClient(
      email, password, location, fullname, image, phoneNumber, context) async {
    assert(password != null);
    final UserCredential userCredential = await auth
        .createUserWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    await uploadClientDetails(
        email, location, fullname, user?.uid, image, phoneNumber);

    return user;
  }

  Future uploadClientDetails(
      email, location, fullname, userId, displayPicture, phoneNumber) async {
    String displayPictureUrl =
        await storage.uploadImage(displayPicture, userId);
    return FirebaseFirestore.instance.collection('clients').doc(userId).set({
      "username": fullname,
      "userLat": 0,
      "userLong": 0,
      "location": location,
      "email": email,
      "phoneNumber": phoneNumber,
      "imageurl": displayPictureUrl
    });
  }

  Future<User?> signInClient(email, password) async {
    assert(password != null);
    final UserCredential userCredential =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User? user = userCredential.user;
    return user;
  }

  Future signOut() async {
    await auth.signOut();
  }

  Future deleteAccount() async {
    await auth.currentUser?.delete();
  }

  bool authState() {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }
    return true;
  }
}
