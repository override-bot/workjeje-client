import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  final db = FirebaseFirestore.instance;
  final String path;
  late CollectionReference ref;

  Api(this.path) {
    ref = db.collection(path);
  }

  Future<QuerySnapshot> getDocuments() async {
    return ref.get();
  }

  Stream<QuerySnapshot> streamDocuments() {
    return ref.snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(id) {
    return ref.doc(id).get();
  }

  Stream<QuerySnapshot> queryWhereIsEqualTo(param, field) {
    return ref.where(field, isEqualTo: param).snapshots();
  }

  Future<DocumentReference> addData(Map data) {
    return ref.add(data);
  }
}
