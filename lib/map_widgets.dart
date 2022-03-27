import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'camera.dart';

class EventMap extends StatefulWidget {
  @override
  State<EventMap> createState() => EventMapState();

  EventMap(this.locId);
  String locId;
}

class EventMapState extends State<EventMap> {
  Completer<GoogleMapController> _controller = Completer();
  EventMapState();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.getLocByID(this.widget.locId),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var data = snapshot.data!["geo"] as GeoPoint;
            LatLng loc = LatLng(data.latitude, data.longitude);
            return Scaffold(
              body: GoogleMap(
                mapType: MapType.normal,
                markers: {
                  Marker(alpha: 1, position: loc, markerId: MarkerId("example"))
                },
                initialCameraPosition: CameraPosition(
                  target: loc,
                  bearing: 0,
                  tilt: 0,
                  zoom: 19,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  print(loc);
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          bearing: 0, target: loc, tilt: 0, zoom: 20)));
                },
                label: Text("Back to location"),
                icon: Icon(Icons.arrow_back_rounded),
              ),
            );
          }
          return LinearProgressIndicator();
        });
  }
}

class RecycleMap extends StatefulWidget {
  @override
  State<RecycleMap> createState() => RecycleMapState();

  RecycleMap();
}

class RecycleMapState extends State<RecycleMap> {
  Completer<GoogleMapController> _controller = Completer();
  RecycleMapState();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.getRecycleBins(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            var pins = (snapshot.data!["loc"] as List<dynamic>).map((e) {
              return Marker(
                  alpha: 1,
                  position: LatLng(e.latitude, e.longitude),
                  markerId: MarkerId("example"));
            }).toList();
            var startLoc = pins[0].position;
            print(pins);
            LatLng loc = LatLng(0, 0);
            return Scaffold(
              body: GoogleMap(
                mapType: MapType.normal,
                markers: pins.toSet(),
                initialCameraPosition: CameraPosition(
                  target: startLoc,
                  bearing: 0,
                  tilt: 0,
                  zoom: 17,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  print(loc);
                  final GoogleMapController controller =
                      await _controller.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          bearing: 0, target: startLoc, tilt: 0, zoom: 17)));
                },
                label: Text('To the initial position'),
                icon: Icon(Icons.arrow_back_rounded),
              ),
            );
          }
          return LinearProgressIndicator();
        });
  }
}

class LocationPickerMap extends StatefulWidget {
  @override
  State<LocationPickerMap> createState() => LocationPickerMapState();
  Function callbackWithPin;

  LocationPickerMap(this.callbackWithPin) {
  }
}

class LocationPickerMapState extends State<LocationPickerMap> {
  LatLng startLoc = LatLng(5.835578666216491, -55.21029678440565);
  Marker? pickedMarker;
  // ^ fetch current location
  late GoogleMap gm = GoogleMap(
    mapType: MapType.hybrid,
    onLongPress: addMarker,
    initialCameraPosition: CameraPosition(
      target: startLoc,
      bearing: 0,
      tilt: 0,
      zoom: 17,
    ),
    onMapCreated: (GoogleMapController controller) {
      _controller.complete(controller);
    },
  );
  Completer<GoogleMapController> _controller = Completer();
  LocationPickerMapState() {
    gm = GoogleMap(
      mapType: MapType.hybrid,
      onLongPress: addMarker,
      initialCameraPosition: CameraPosition(
        target: startLoc,
        bearing: 0,
        tilt: 0,
        zoom: 17,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  void addMarker(LatLng m) {
    print(m);
    this.widget.callbackWithPin(GeoPoint(m.latitude, m.longitude));

    setState(() {
      pickedMarker =
          Marker(markerId: MarkerId("example"), position: m, alpha: 1);
      gm = GoogleMap(
        mapType: MapType.hybrid,
        onLongPress: addMarker,
        markers: (pickedMarker == null) ? {} : {pickedMarker!},
        initialCameraPosition: CameraPosition(
          target: m,
          bearing: 0,
          tilt: 0,
          zoom: 17,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: gm,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final GoogleMapController controller = await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(bearing: 0, target: startLoc, tilt: 0, zoom: 20)));
        },
        label: Text('To the initial position'),
        icon: Icon(Icons.arrow_back_rounded),
      ),
    );
  }
}
