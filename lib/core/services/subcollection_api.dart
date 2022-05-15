import 'package:cloud_firestore/cloud_firestore.dart';

class SubCollectionApi {
  final db = FirebaseFirestore.instance;
  final String parentPath;
  final String doc;
  final String childPath;
  late CollectionReference ref;

  SubCollectionApi(this.parentPath, this.childPath, this.doc) {
    ref = db.collection(parentPath).doc(doc).collection(childPath);
  }

  Future<QuerySnapshot> getDocuments() async {
    return ref.get();
  }

  Stream<QuerySnapshot> streamDocuments() {
    return ref.snapshots();
  }

  Stream<DocumentSnapshot> streamDocumentById(id) {
    return ref.doc(id).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(id) {
    return ref.doc(id).get();
  }

  Future<QuerySnapshot> getWhereIsEqualTo(param, field) {
    return ref.where(field, isEqualTo: param).get();
  }

  Future<QuerySnapshot> getWhereIsNotEqualTo(param, field) {
    return ref.where(field, whereNotIn: param).get();
  }

  Stream<QuerySnapshot> queryWhereIsEqualTo(param, field) {
    return ref.where(field, isEqualTo: param).snapshots();
  }

  Future<DocumentReference> addData(Map data) {
    return ref.add(data);
  }

  Future updateDocument(field, value, docId) {
    return ref.doc(docId).update({field: value});
  }

  Future setData(id, data) {
    return ref.doc(id).set(data);
  }

  deleteDocument(id) {
    ref.doc(id).delete();
  }
}
