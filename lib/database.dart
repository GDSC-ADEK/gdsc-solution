import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'models/locationtype.dart';
import "models/location.dart";

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference eventCollection =
    FirebaseFirestore.instance.collection('Events');

class Fdatabase {
  final CollectionReference LocTypes =
      FirebaseFirestore.instance.collection('LocationTypes');
  final CollectionReference locs =
      FirebaseFirestore.instance.collection('Locations');
  final CollectionReference roles =
      FirebaseFirestore.instance.collection('Roles');
  final CollectionReference events =
      FirebaseFirestore.instance.collection('Events');
  Stream<QuerySnapshot> getLTs() => LocTypes.snapshots();
  Stream<QuerySnapshot> getLocs() => locs.snapshots();
  Stream<QuerySnapshot> getRoles() => roles.snapshots();
  Stream<QuerySnapshot> getEvents() => events.snapshots();

  Future<DocumentReference> addLocType(LocationType lt) {
    return LocTypes.add(lt.toJson());
  }

  void updateLocType(LocationType lt) async {
    await LocTypes.doc(lt.id).update(lt.toJson());
  }

  void deleteLocType(LocationType lt) async {
    await LocTypes.doc(lt.id).delete();
  }
}
