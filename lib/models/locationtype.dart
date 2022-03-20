import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';



class LocationType {
  LocationType(this.name, {this.id});
   String name;
  String? id;

  factory LocationType.fromJson(Map<String, Object?> json) {
    return LocationType(json["name"] as String);
  }
  Map<String, Object?> toJson() => LTTtoJson(this);

  factory LocationType.fromSnapshot(DocumentSnapshot snapshot) {
    var newLT = LocationType.fromJson(snapshot.data() as Map<String, dynamic>);
    newLT.id = snapshot.reference.id;
    return newLT;
  }
  String toString() => toJson().toString();
}

LocationType LTfromJson(Map<String, Object?> json){
  return LocationType(json["name"] as String);
}

Map<String, Object?>  LTTtoJson(LocationType lt){
    return{
      "name": lt.name,
      "id": lt.id
    };
}





