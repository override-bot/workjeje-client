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

  Future<QuerySnapshot> getWhereIsEqualTo(param, field) {
    return ref.where(field, isEqualTo: param).get();
  }

  Future updateDocument(field, value, docId) {
    return ref.doc(docId).update({field: value});
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

  Future setData(Map data, id) {
    return ref.doc(id).set(data);
  }

  Future<QuerySnapshot> queryWhereArrayContains(param, field) {
    return ref.where(field, arrayContains: param).get();
  }

  deleteDocument(id) {
    ref.doc(id).delete();
  }
}
