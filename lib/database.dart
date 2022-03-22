import 'dart:typed_data';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as store;
import "package:uuid/uuid.dart";
import 'package:flutter/cupertino.dart';
import 'models/locationtype.dart';
import "models/location.dart";
import "models/events.dart";

FirebaseFirestore firestore = FirebaseFirestore.instance;
store.FirebaseStorage storage = store.FirebaseStorage.instance;
CollectionReference eventCollection =
    FirebaseFirestore.instance.collection('Events');
Uuid _uuid = Uuid();

class Fdatabase {
  final CollectionReference _LocTypes =
      FirebaseFirestore.instance.collection('LocationTypes');
  final CollectionReference _locs =
      FirebaseFirestore.instance.collection('Locations');
  final CollectionReference _roles =
      FirebaseFirestore.instance.collection('Roles');
  final CollectionReference _events =
      FirebaseFirestore.instance.collection('Events');
  Stream<QuerySnapshot> getLTs() => _LocTypes.snapshots();
  Stream<QuerySnapshot> getLocs() => _locs.snapshots();
  Stream<QuerySnapshot> getRoles() => _roles.snapshots();
  Stream<QuerySnapshot> getEvents() => _events.snapshots();

  Future<DocumentSnapshot> getLTByID(String id) {
    return _LocTypes.doc(id.trim()).get();
  }

  Future<DocumentSnapshot> getLocByID(String id) {
    return _locs.doc(id.trim()).get();
  }

  Future<DocumentSnapshot> getEventByID(String id) {
    return _events.doc(id.trim()).get();
  }

  Future<DocumentReference> addLocType(LocationType lt) {
    return _LocTypes.add(lt.toJson());
  }

  // locations
  void updateLocType(LocationType lt) async {
    await _LocTypes.doc(lt.id).update(lt.toJson());
  }

  void deleteLocType(LocationType lt) async {
    await _LocTypes.doc(lt.id).delete();
  }

  Future<DocumentReference> addLoc(Location l) {
    return _locs.add(l.toJson());
  }

  void updateLoc(Location l) async {
    await _locs.doc(l.id).update(l.toJson());
  }

  void deleteLoc(Location l) async {
    await _locs.doc(l.id).delete();
  }

  Future<DocumentReference> addEvent(Event e) {
    return _events.add(e.toJson());
  }

  void updateEvent(Event e) async {
    await _events.doc(e.id).update(e.toJson());
  }

  void deleteEvent(Event e) async {
    await _events.doc(e.id).delete();
  }

  Stream<QuerySnapshot> getClosedEvents() =>
      _events.where("complete", isEqualTo: true).snapshots();
  Stream<QuerySnapshot> getOpenEvents() =>
      _events.where("complete", isEqualTo: false).snapshots();
  Stream<QuerySnapshot> getJoinedEvents(String userid) =>
      _events.where("participants", arrayContains: userid).snapshots();
  Stream<QuerySnapshot> getOrganizedEvents(String userid) =>
      _events.where("organizers", arrayContains: userid).snapshots();

  Future<String> getImgUrl(String imagePath) async {
    try {
      String downloadURL =
          await store.FirebaseStorage.instance.ref(imagePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e);
    }
    return await "";
  }

  Future<Image> getImg(String imagePath) async {
    try {
      var img = await store.FirebaseStorage.instance.ref(imagePath).getData();
      return Image.memory(img!);
    } catch (e) {
      print(e);
      return await Image.memory(Uint8List(0));
    }
  }

  Future<String> uploadImage(File img, {bool before = true}) async {
    String folder = (before) ? "beforePictures/" : "afterPictures/";
    String filename = folder + _uuid.v4();
    Uint8List imgData = img.readAsBytesSync();
    try {
      await store.FirebaseStorage.instance
          .ref('uploads/file-to-upload.png')
          .putData(imgData);
      return filename;
    } on firebase_core.FirebaseException catch (e) {
      print("error");
      return await "";
    }
  }

  void uploadBeforeImgToEvent(Event event, File image) {
    var path = uploadImage(image, before: true);
    path.then((value) {
      event.beforePictures.add(value);
      updateEvent(event);
    });
  }

  void uploadAfterImgToEvent(Event event, File image) {
    var path = uploadImage(image, before: false);
    path.then((value) {
      event.afterPictures.add(value);
      updateEvent(event);
    });
  }

  Map<String, List<Future<Image>>> getImgsFromEvent(Event e) {
    var before = e.beforePictures.map((e) => getImg(e)).toList();
    var after = e.afterPictures.map((e) => getImg(e)).toList();
    return {"before": before, "after": after};
  }
}
