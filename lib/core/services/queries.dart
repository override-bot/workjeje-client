import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final User? user = FirebaseAuth.instance.currentUser;

//single data queries
class SingleQueries {
  Future<List> getProfession() async {
    final userInfo = await FirebaseFirestore.instance
        .collection("providers")
        .doc(user?.uid)
        .get();
    Map<String, dynamic>? data() {
      Map<String, dynamic>? data = userInfo.data();
      return data;
    }

    List profession = data()!["skill"];
    return profession;
  }

  Future<String> getLocation() async {
    final userInfo = await FirebaseFirestore.instance
        .collection("providers")
        .doc(user?.uid)
        .get();
    Map<String, dynamic>? data() {
      Map<String, dynamic>? data = userInfo.data();
      return data;
    }

    String location = data()!["location"];
    return location;
  }
}

SingleQueries singleQueries = SingleQueries();

//FirebaseQueries
class FirebaseQueries {
  Future<DocumentSnapshot<Map<String, dynamic>>> getCategoryDoc() {
    DocumentReference<Map<String, dynamic>> categories;
    categories = FirebaseFirestore.instance
        .collection("JobCategories")
        .doc("XUbWjrISV6KfFYqtJ5vl");
    return categories.get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProvidersByCategory(category) {
    Query<Map<String, dynamic>> providers;
    providers = FirebaseFirestore.instance
        .collection('providers')
        .where("subcategories", arrayContains: category)
        .orderBy("rating", descending: true);

    return providers.snapshots();
  }
}
