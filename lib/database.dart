import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'models/locationtype.dart';
import "models/location.dart";
import "models/events.dart";

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

  Future<DocumentSnapshot> getLTByID(String id) {
    return LocTypes.doc(id.trim()).get();
  }

  Future<DocumentSnapshot> getLocByID(String id) {
    return locs.doc(id.trim()).get();
  }

  Future<DocumentSnapshot> getEventByID(String id) {
    return events.doc(id.trim()).get();
  }

  Future<DocumentReference> addLocType(LocationType lt) {
    return LocTypes.add(lt.toJson());
  }

  void updateLocType(LocationType lt) async {
    await LocTypes.doc(lt.id).update(lt.toJson());
  }

  void deleteLocType(LocationType lt) async {
    await LocTypes.doc(lt.id).delete();
  }

  Future<DocumentReference> addLoc(Location l) {
    return locs.add(l.toJson());
  }

  void updateLoc(Location l) async {
    await locs.doc(l.id).update(l.toJson());
  }

  void deleteLoc(Location l) async {
    await locs.doc(l.id).delete();
  }

  Future<DocumentReference> addEvent(Event e) {
    return events.add(e.toJson());
  }

  void updateEvent(Event e) async {
    await events.doc(e.id).update(e.toJson());
  }

  void deleteEvent(Event e) async {
    await events.doc(e.id).delete();
  }

  Stream<QuerySnapshot> getClosedEvents() =>
      events.where("complete", isEqualTo: true).snapshots();
  Stream<QuerySnapshot> getOpenEvents() =>
      events.where("complete", isEqualTo: false).snapshots();
  Stream<QuerySnapshot> getJoinedEvents(String userid) =>
      events.where("participants", arrayContains: userid).snapshots();
  Stream<QuerySnapshot> getOrganizedEvents(String userid) =>
      events.where("organizers", arrayContains: userid).snapshots();
}
