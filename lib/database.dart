import 'dart:convert';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as store;
import "package:uuid/uuid.dart";
import 'package:flutter/cupertino.dart';
import 'models/locationtype.dart';
import "models/location.dart";
import "models/events.dart";

/// Fdatabase is
class Fdatabase {
  Fdatabase._();

  factory Fdatabase() => _instance;
  static Fdatabase _instance = Fdatabase._();
  final Uuid _uuid = Uuid();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final store.FirebaseStorage storage = store.FirebaseStorage.instance;
  final CollectionReference _LocTypes =
      FirebaseFirestore.instance.collection('LocationTypes');
  final CollectionReference _locs =
      FirebaseFirestore.instance.collection('Locations');
  final CollectionReference _roles =
      FirebaseFirestore.instance.collection('Roles');
  final CollectionReference _events =
      FirebaseFirestore.instance.collection('Events');

  /// fetches all LocationType documents
  Stream<QuerySnapshot> getLTs() => _LocTypes.snapshots();

  /// fetches all Location documents
  Stream<QuerySnapshot> getLocs() => _locs.snapshots();

  /// fetches all Role documents
  Stream<QuerySnapshot> getRoles() => _roles.snapshots();

  /// fetches all Event documents
  Stream<QuerySnapshot> getEvents() => _events.snapshots();

  /// Fetches LocationType by id
  Future<DocumentSnapshot> getLTByID(String id) {
    return _LocTypes.doc(id.trim()).get();
  }

  /// Fetches Location by id
  Future<DocumentSnapshot> getLocByID(String id) {
    return _locs.doc(id.trim()).get();
  }

  /// Fetches Event by id
  Future<DocumentSnapshot> getEventByID(String id) {
    return _events.doc(id.trim()).get();
  }

  /// adds LocationType to database
  Future<DocumentReference> addLocType(LocationType lt) {
    return _LocTypes.add(lt.toJson());
  }

  /// updates LocationType in database
  void updateLocType(LocationType lt) async {
    await _LocTypes.doc(lt.id).update(lt.toJson());
  }

  /// deletes LocationType from database
  void deleteLocType(LocationType lt) async {
    await _LocTypes.doc(lt.id).delete();
  }

  /// Adds location to database
  Future<DocumentReference> addLoc(Location l) {
    return _locs.add(l.toJson());
  }

  /// updates location in database
  void updateLoc(Location l) async {
    await _locs.doc(l.id).update(l.toJson());
  }

  /// deletes location in database
  void deleteLoc(Location l) async {
    await _locs.doc(l.id).delete();
  }

  /// adds Event to database
  Future<DocumentReference> addEvent(Event e) {
    return _events.add(e.toJson());
  }

  /// Updates existing Event in database
  void updateEvent(Event e) async {
    await _events.doc(e.id).update(e.toJson());
  }

  /// deletes Event in database
  void deleteEvent(Event e) async {
    await _events.doc(e.id).delete();
  }

  /// gets all events which have been completed
  Stream<QuerySnapshot> getClosedEvents() =>
      _events.where("complete", isEqualTo: true).snapshots();

  /// gets all events which are still incomplete
  Stream<QuerySnapshot> getOpenEvents() =>
      _events.where("complete", isEqualTo: false).snapshots();

  /// gets all events which a user has joined
  Stream<QuerySnapshot> getJoinedEvents(String userid) =>
      _events.where("participants", arrayContains: userid).snapshots();

  /// gets all events which a user has organized
  Stream<QuerySnapshot> getOrganizedEvents(String userid) =>
      _events.where("organizers", arrayContains: userid).snapshots();

  /// retrieves an url which can be used to download the image
  /// from the firestore path
  Future<String> getImgUrl(String imagePath) async {
    try {
      String downloadURL =
          await store.FirebaseStorage.instance.ref(imagePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(
          "---------------error in getImageUrl--------------------------------------");
      print(e);
    }
    return await "";
  }

  /// fetches image which can  be  inmediately used
  /// from the firestore path
  Future<Image> getImg(String imagePath) async {
    try {
      var img = await store.FirebaseStorage.instance.ref(imagePath).getData();
      return Image.memory(img!);
    } catch (e) {
      print(
          "---------------error in getImage--------------------------------------");
      print(e);
      return await Image.memory(Uint8List(0));
    }
  }

  /// fetches all images related to an event
  Map<String, List<Future<Image>>> getImgsFromEvent(Event e) {
    var before = e.beforePictures.map((e) => getImg(e)).toList();
    var after = e.afterPictures.map((e) => getImg(e)).toList();
    return {"before": before, "after": after};
  }

  /// upload an image to firestore
  Future<String> uploadImage(File img, {bool before = true}) async {
    String folder = (before) ? "beforePictures/" : "afterPictures/";
    String filename = folder + _uuid.v4();
    try {
      await store.FirebaseStorage.instance.ref(filename).putFile(img);
      return filename;
    } on firebase_core.FirebaseException catch (e) {
      print(
          "---------------error in uploadImage--------------------------------------");
      print(e);
      return await "";
    }
  }

  /// uploads an image and adds the firebase path of it
  /// to event.beforePictures
  void uploadBeforeImgToEvent(Event event, File image) {
    var path = uploadImage(image, before: true);
    path.then((value) {
      event.beforePictures.add(value);
      updateEvent(event);
    });
  }

  /// uploads an image and adds the firebase path of it
  /// to event.afterPictures
  void uploadAfterImgToEvent(Event event, File image) {
    var path = uploadImage(image, before: false);
    path.then((value) {
      event.afterPictures.add(value);
      updateEvent(event);
    });
  }
}
