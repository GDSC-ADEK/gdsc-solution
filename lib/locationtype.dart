import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';

part 'locationtype.g.dart';

@JsonSerializable()
class LocationType {
  LocationType(this.name);
  final String name;

  factory LocationType.fromJson(Map<String, Object?> json) =>
      _$LocationTypeFromJson(json);
  Map<String, Object?> toJson() => _$LocationTypeToJson(this);
  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Geo {
  Geo(this.Latitude, this.Longitude);
  String Latitude;
  String Longitude;
  factory Geo.fromJson(Map<String, Object?> json) => _$GeoFromJson(json);
  Map<String, Object?> toJson() => _$GeoToJson(this);
  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Location {
  Location(this.loc, this.type);
  final Geo loc;
  final LocationTypeDocumentReference type;
  factory Location.fromJson(Map<String, Object?> json) =>
      _$LocationFromJson(json);
  Map<String, Object?> toJson() => _$LocationToJson(this);
  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Role {
  Role(this.name, this.members);
  final String name;
  final members;
  factory Role.fromJson(Map<String, Object?> json) => _$RoleFromJson(json);
  Map<String, Object?> toJson() => _$RoleToJson(this);

  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Event {
  Event(
      this.name,
      this.description,
      this.creationDate,
      this.orgDate,
      this.organizers,
      this.participants,
      this.beforePictures,
      this.afterPictures,
      this.garbageCollected,
      this.location);
  final String name;
  final String description;
  final bool complete = false;
  final bool publish = false;
  final DateTime creationDate;
  final DateTime orgDate;
  final organizers;
  final participants;
  final beforePictures; // list of urls to pics? not sure yet
  final afterPictures;
  final num garbageCollected;
  final LocationDocumentReference location;
  factory Event.fromJson(Map<String, Object?> json) => _$EventFromJson(json);
  Map<String, Object?> toJson() => _$EventToJson(this);

  @override
  String toString() => toJson().toString();
}

@Collection<LocationType>('LocationTypes')
final LTRef = LocationTypeCollectionReference();
@Collection<Location>('Locations')
final locRefs = LocationCollectionReference();
@Collection<Role>('Roles')
final roleRefs = RoleCollectionReference();
@Collection<Event>('Events')
final eventRefs = EventCollectionReference();

// vanaf hier is niet wat je gebruikt als je de ODM gebruikt
var locTypeJson = {"name": "somename"};
var locJson = {
  "loc": {"Longitude": "", "Latitude": ""},
  "type": "idk, I expect a link to the LT type"
};
var roleJson = {
  "name": "",
  "members": [""]
};
var EventJson = {
  "name": "",
  "description": "",
  "complete": false,
  "publish": false,
  "creationDate": "2012-04-23T18:25:43.511Z",
  "orgDate": "2012-04-23T18:25:43.511Z",
  "organizers": [""],
  "participants": [""],
  "beforePictures": [""], // list of urls to pics? not sure yet
  "afterPictures": [""],
  "garbageCollected": 0,
  "location": "", // url of location? not sure
};

var endpoints = {
  "/LocationTypes": List<LocationType>,
  "LocationTypes/{ID}": LocationType,
  "/Locations": List<Location>,
  "/Locations": Location,
  "Roles/": List<Role>,
  "Roles/Organizer": Role("Organizer", []),
  "/Events/": List<Event>,
  "Events/{ID}": Event
};

// tot hier is niet wat je voor odm gebruikt


