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


class Geo {
  Geo(this.latitude, this.longitude);
  Geo.fromGP(GeoPoint gp): latitude = gp.latitude, longitude=gp.longitude;
  num latitude;
  num longitude;
  factory Geo.fromJson(Map<String, Object?> json) {
    return Geo(json["latitude"] as double, json["longitude"] as double);
  }
  Map<String, Object?> toJson(){
    return {
      "latitude" : latitude,
      "longitude" : longitude
    };
  }
  @override
  String toString() => toJson().toString();
}

@JsonSerializable()
class Location {
  Location(this.geo, this.type);
  final Geo geo;
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
  final List<String> organizers;
  final List<String> participants;
  final List<String> beforePictures; // list of urls to pics? not sure yet
  final List<String> afterPictures;
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



