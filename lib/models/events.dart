import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'locationtype.dart';
import "location.dart";

class Event {
  Event(
      this.name,
      this.description,
      this.complete,
      this.publish,
      this.creationDate,
      this.orgDate,
      this.organizers,
      this.participants,
      this.beforePictures,
      this.afterPictures,
      this.garbageCollected,
      this.location,
      this.wasteTypes,
      this.firstTimeAtLoc,
      this.recycled,
      this.numPlasticBottles,
      this.numPresent,
      this.collabWithOrg);
  String name;
  String description;
  bool complete;
  bool publish;
  DateTime creationDate;
  DateTime orgDate;
  List<String> organizers;
  List<String> participants;
  List<String> beforePictures; // list of urls to pics? not sure yet
  List<String> afterPictures;
  num garbageCollected;
  DocumentReference location;
  String? id;
  Map<String, String>? changes = null;
  String
      wasteTypes; // What type of waste was collected? (metal, plastic, electronics, glas, etc)
  bool firstTimeAtLoc; // Was there a clean up day held at the location before?
  bool recycled; // Was the waste recycled?
  int numPlasticBottles; // In case the waste was recycled, how many plastic bottles were disposed in the recycle bins?
  int numPresent; // How many volunteers were present?
  bool
      collabWithOrg; // Was there a collaboration with an environmental organisation?

  void toggleParticipation(String uuid) {
    if (changes == null) {
      changes = {};
    }
    print(participants);
    bool participating = participants.contains(uuid);
    if (participating) {
      participants.remove(uuid);
      changes?["unjoined"] = uuid;
    } else {
      participants.add(uuid);
      changes?["joined"] = uuid;
    }
  }

  factory Event.fromJson(Map<String, Object?> json) => eventFromJson(json);
  factory Event.fromSnapshot(DocumentSnapshot snapshot) =>
      eventFromSnapshot(snapshot);
  Map<String, Object?> toJson() => eventToJson(this);

  @override
  String toString() => toJson().toString();
}

Event eventFromJson(Map<String, Object?> json) {
  DateTime create = DateTime.now();
  DateTime org = DateTime.now();
  try {
    if (json["creationDate"] is Timestamp) {
      create = (json["creationDate"] as Timestamp).toDate();
      org = (json["orgDate"] as Timestamp).toDate();
    } else if (json["creationDate"] is int) {
      create = DateTime.fromMillisecondsSinceEpoch(json["creationDate"] as int);
      org = DateTime.fromMillisecondsSinceEpoch(json["orgDate"] as int);
    } else if (json["creationDate"] is DateTime) {
      create = json["creationDate"] as DateTime;
      org = json["creationDate"] as DateTime;
    }
  } catch (e) {
    print(e);
  }
  var loc = json["location"] as DocumentReference;
  return Event(
    json["name"] as String,
    json["description"] as String,
    json["complete"] as bool,
    json["publish"] as bool,
    create,
    org,
    (json["organizers"] as List<dynamic>).cast<String>(),
    (json["participants"] as List<dynamic>).cast<String>(),
    (json["beforePictures"] as List<dynamic>).cast<String>(),
    (json["afterPictures"] as List<dynamic>).cast<String>(),
    json["garbageCollected"] as num,
    loc,
    json["wasteTypes"] as String,
    json['firstTimeAtLoc'] as bool,
    json['recycled'] as bool,
    json['numPlasticBottles'] as int,
    json['numPresent'] as int,
    json['collabWithOrg'] as bool,
  );
}

Map<String, Object?> eventToJson(Event e) {
  return {
    "name": e.name,
    "description": e.description,
    "complete": e.complete,
    "publish": e.publish,
    "creationDate": e.creationDate,
    "orgDate": e.orgDate,
    "organizers": e.organizers,
    "participants": e.participants,
    "beforePictures": e.beforePictures,
    "afterPictures": e.afterPictures,
    "garbageCollected": e.garbageCollected,
    "location": e.location,
    "wasteTypes": e.wasteTypes,
    "firstTimeAtLoc": e.firstTimeAtLoc,
    "recycled": e.recycled,
    "numPlasticBottles": e.numPlasticBottles,
    "numPresent": e.numPresent,
    "collabWithOrg": e.collabWithOrg
  };
}

Event eventFromSnapshot(DocumentSnapshot snapshot) {
  var newEvent = eventFromJson(snapshot.data() as Map<String, dynamic>);
  newEvent.id = snapshot.reference.id;
  return newEvent;
}

// var evs = [
//   {
// "name": "Cleanup Kwatta",
// "description": "A description that's a bit long so you have to figure out how to handle it. It is very long, so I suspect you just need to remove the description completely from listviews. It might contain details such as the locations, what to wear, what to bring (for example, a rake, gloves, water), what will be provided (tools, water), the time to meet at, the location to gather, idk. I should probably just lorem ipsum this",
// "complete": true,
// "publish": true,
// "creationDate": DateTime(2021,03, 23 ),
// "orgDate":DateTime(2021,03, 23 ),
// "organizers": ["dernz"],
// "participants": ["sagar"],
// "beforePictures": ["beforePictures/check.webp", "beforePictures/uncheck.png"],
// "afterPictures": ["afterPictures/check.webp", "afterPictures/uncheck.png"],
// "garbageCollected": 0,
// "location": ""
// }
// ];
