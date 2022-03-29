import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'locationtype.dart';

class Location {
  Location(this.geo, this.type);
  GeoPoint geo;
  DocumentReference type;
  String? id;

  factory Location.fromJson(Map<String, Object?> json) =>
      LocationfromJson(json);
  factory Location.fromSnapshot(DocumentSnapshot snapshot) =>
      LocationfromSnapshot(snapshot);
  Map<String, Object?> toJson() => LocationToJson(this);
  @override
  String toString() => toJson().toString();
}

Location LocationfromJson(Map<String, Object?> json) {
  var type = json["type"] as DocumentReference;
  return Location(json["geo"] as GeoPoint, type);
}

Map<String, Object?> LocationToJson(Location l) {
  return {"geo": l.geo, "type": l.type};
}

Location LocationfromSnapshot(DocumentSnapshot snapshot) {
  var newLoc = LocationfromJson(snapshot.data() as Map<String, dynamic>);
  newLoc.id = snapshot.reference.id;
  return newLoc;
}
