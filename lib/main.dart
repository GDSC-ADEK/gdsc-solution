/*
less firebase-debug.log -> https://stackoverflow.com/questions/63995958/firebase-init-functions-returns-403-caller-does-not-have-permission
flutter build apk -> https://docs.flutter.dev/release/breaking-changes/kotlin-version
https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0
https://firebase.flutter.dev/docs/auth/usage
https://firebase.flutter.dev/docs/auth/social/

google sign in example -> https://github.com/flutter/plugins/blob/master/packages/google_sign_in/google_sign_in/example/lib/main.dart

camera -> https://docs.flutter.dev/cookbook/plugins/picture-using-camera
*/

//python -m http.server 8000
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'database.dart';
import "models/location.dart";
import "models/locationtype.dart";
import 'models/events.dart';
import 'models/role.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'camera.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } catch (e, st) {
    print(e);
    print(st);
  }
  await initializefirstCamera();
  runApp(MyApp());
}

Fdatabase db = Fdatabase();
String? userID;

class MyAppState extends ChangeNotifier {
  bool _isNGO = false;
  bool _myevents = false;

  bool get isNGO => _isNGO;
  set isNGO(bool value) {
    _isNGO = value;
    notifyListeners();
  }

  bool get myevents => _myevents;
  set myevents(bool value) {
    _myevents = value;
    notifyListeners();
  }

  Future<UserCredential> signInAnonymously() async {
    return FirebaseAuth.instance.signInAnonymously();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => MyAppState(),
        //child: MaterialApp(home: LoginScreen()),
        child: MaterialApp(
            home: FutureBuilder(
          future:
              Firebase.initializeApp(options: DefaultFirebaseOptions.android),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Cannot initialize firebase');
            }

            // Once complete, show your application
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            return LoginScreen();
          },
        )),
      );
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool RequestNGO = false;
  Widget build(BuildContext context) => StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            return Text("Error in authentication");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }

          var user = snapshot.data;
          if (user != null) {
            userID = user.uid;
            return FutureBuilder<DocumentSnapshot>(
              future: db.getRoleByID('organizer'),
              builder: (context, snapshot) {
                if (snapshot.hasError) return Text('Error loading roles');
                if (snapshot.connectionState == ConnectionState.waiting)
                  return LinearProgressIndicator();
                if (!snapshot.hasData || snapshot.data == null)
                  return Text('Role snapshot has no data');
                print(snapshot.data!.toString());
                final r = Role.fromSnapshot(snapshot.data!);
                if (RequestNGO) {
                  if (r.members.contains(userID)) {
                    //TODO remove later
                    Provider.of<MyAppState>(context, listen: false)._isNGO =
                        true;
                    return EventScreen(); //isNGO must be set somehow
                  } else {
                    String? encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map((e) =>
                              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                          .join('&');
                    }

                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'uvsgdsc@gmail.com',
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Request NGO account',
                        'body':
                            'Hello, I am ${user.displayName} and I would like to request an NGO account.\nUSER ID: ${user.uid}'
                      }),
                    );

                    launch(emailLaunchUri.toString());
                    return EventScreen();
                  }
                }
                return EventScreen();
              },
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text('Login')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Sign in as participant'),
                    onPressed: () async {
                      //Ik moet gaan kijken hoe try catch blocks werken
                      //TODO try and catch werken niet met Future zonder await gerbuik in de plaats callbacks
                      try {
                        await Provider.of<MyAppState>(context, listen: false)
                            // .signInWithGoogle();
                            .signInAnonymously();
                      } on FirebaseAuthException catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Text('Login error'),
                                content: Text(e.code)));
                      }
                      setState(() {
                        RequestNGO = false;
                      });
                    },
                  ),
                  ElevatedButton(
                    child: Text('Sign in as NGO'),
                    onPressed: () async {
                      try {
                        await Provider.of<MyAppState>(context, listen: false)
                            // .signInWithGoogle();
                            .signInAnonymously();
                      } on FirebaseAuthException catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Text('Login error'),
                                content: Text(e.code)));
                      }
                      setState(() {
                        RequestNGO = true;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
}

class EventScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EventScreenDrawer(),
      appBar: AppBar(
          title: Consumer<MyAppState>(
              builder: (context, state, _) => Text(
                    state.myevents ? 'My events!' : 'All events!',
                    textScaleFactor: 1.5,
                  ))),
      body: Consumer<MyAppState>(builder: (context, state, _) {
        final retwidget = <Widget>[];
        retwidget.add(SizedBox(height: 20));
        if (state.myevents) {
          retwidget.add(Text(
            state.isNGO ? 'Events by me' : 'Events I joined',
            textScaleFactor: 1.5,
          ));
          retwidget.add(Expanded(
              child: EventList(state.isNGO
                  ? db.getEvents(organizer: userID)
                  : db.getEvents(participant: userID))));
        } else {
          retwidget.add(
            Text(
              'Open events!',
              textScaleFactor: 1.5,
            ),
          );
          retwidget.add(Expanded(
              child:
                  EventList(db.getEvents(completed: false, published: true))));
          retwidget.add(Divider());
          retwidget.add(
            Text(
              'Closed events!',
              textScaleFactor: 1.5,
            ),
          );
          retwidget.add(Container(
              height: 80,
              child: ClosedEventList(
                  db.getEvents(completed: true, published: true))));

          // Expanded(child: LocList()),
          // Expanded(child: LocTypeList()),
          // Expanded(child: RolesList()),

        }
        retwidget.add(Divider());
        retwidget.add(Row(
          children: [
            Expanded(
              child: Container(
                height: 60,
                child: TextButton(
                  child: Text('Statistics'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => StatisticsScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Consumer<MyAppState>(
                builder: (context, state, _) => Container(
                  height: 60,
                  child: !state.isNGO
                      ? null
                      : TextButton(
                          child: Text('Organize'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    OrganizeScreen(),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ));
        return Column(children: retwidget);
      }),
    );
  }
}

class EventScreenDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'View',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              //TODO Use popUntil LoginScreen
              Provider.of<MyAppState>(context, listen: false).signOut();
            },
            child: ListTile(
              title: Text('SignOut'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<MyAppState>(context, listen: false).myevents = false;
            },
            child: ListTile(
              title: Text('All events'),
            ),
          ),
          Consumer<MyAppState>(
            builder: (context, state, _) => TextButton(
              onPressed: () {
                Navigator.pop(context);
                state.myevents = true;
              },
              child: ListTile(
                title: Text('My events'),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              var state = Provider.of<MyAppState>(context, listen: false);
              state.isNGO = !state.isNGO;
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Toggle NGO'),
            ),
          ),
        ],
      ),
    );
  }
}

class dbPicture extends StatelessWidget {
  final String path;
  dbPicture(this.path);

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: db.getImg(path),
        builder: (context, AsyncSnapshot<Image> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && snapshot.data == null) {
            return Text("Image does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          }

          return CircularProgressIndicator();
        });
  }
}

class EventPicturePages extends StatelessWidget {
  final Event e;
  final bool before;
  EventPicturePages(this.e, {this.before = true});

  Widget build(BuildContext context) {
    //return dbPicture(e.beforePictures[0]);
    //PageView heeft een unbounded height problem in dit geval
    final pictures = before ? e.beforePictures : e.afterPictures;
    return Container(
        height: 300,
        child: PageView(
          controller: PageController(),
          children: [for (var path in pictures) dbPicture(path)],
        ));
  }
}

class EventTile extends StatelessWidget {
  EventTile(this.e);
  final Event e;
  Widget build(BuildContext context) {
    final pictureToDisplay =
        e.complete ? e.afterPictures[0] : e.beforePictures[0];
    return Container(
      color: e.organizers.contains(userID)
          ? Colors.redAccent
          : (e.participants.contains(userID) ? Colors.lightGreenAccent : null),
      child: ListTile(
        title: TextButton(
            onPressed: (() => Navigator.push(context,
                MaterialPageRoute(builder: (context) => EventDetail(e)))),
            child: Text('${e.name}')),
        subtitle: Text('Date: ${e.orgDate}'),
        leading: TextButton(
            onPressed: (() => showDialog(
                context: context,
                builder: (context) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EventPicturePages(e, before: !e.complete),
                          ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('back'))
                        ]))),
            child: dbPicture(pictureToDisplay)),
      ),
    );
  }
}

class EventPanelList extends StatefulWidget {
  final Event e;
  EventPanelList(this.e);
  @override
  State<EventPanelList> createState() => _EventPanelListState();
}

class _EventPanelListState extends State<EventPanelList> {
  bool isExpanded = false;
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (panelIndex, isExpanded) => setState(() {
        this.isExpanded = !isExpanded;
      }),
      children: [
        ExpansionPanel(
            headerBuilder: (context, isExpanded) =>
                ListTile(title: Text('Description')),
            body: ListTile(title: Text(widget.e.description)),
            isExpanded: isExpanded)
      ],
    );
  }
}

class EventDetail extends StatefulWidget {
  final Event e;

  EventDetail(this.e);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final int max_attendees = 20;

  final String phone_number = '+5978855645';

  Widget build(BuildContext context) {
    //Event e = Event.fromSnapshot(await db.getEventByID(widget.e.id));
    return StreamBuilder(
        stream: db.getEventByID(this.widget.e.id!),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Event ${this.widget.e.id} does not exist");
          }

          if (snapshot.connectionState != ConnectionState.done) {
            return LinearProgressIndicator();
          }

          var e = Event.fromSnapshot(snapshot.data!);
          return Scaffold(
            appBar: AppBar(
              title: Text(e.name),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      EventPicturePages(e, before: !e.complete),
                      EventPanelList(e),
                      ListTile(title: Text('Day organized: ${e.orgDate}')),
                      ListTile(
                          title:
                              Text('Max number of attendees: $max_attendees')),
                      ListTile(
                          title: Text(
                              'Current number of sign ups: ${e.participants.length}')),
                      FutureBuilder<DocumentSnapshot>(
                        future: db.getLocByID(e.location.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return Text(
                                "Document \"${e.location.id}\" does not exist");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return Container(
                              height: 400,
                              width: 400,
                              child: EventMap(e.location.id),
                              // child: MapSample(),
                            );
                          }

                          return LinearProgressIndicator();
                        },
                      ),
                      ListTile(
                        title: Text('Phone number lead: $phone_number'),
                        subtitle: Text('(will get send to the participants)'),
                      ),
                    ],
                  ),
                ),
                Consumer<MyAppState>(builder: (context, state, _) {
                  if (e.organizers.contains(userID))
                    return ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WrapUpScreen(e))),
                      child: Text('Wrap up'),
                    );
                  bool joined = e.participants.contains(userID);
                  return ElevatedButton(
                    onPressed: () {
                      //TODO replace with e.toggleParticipation(userID!);
                      if (joined)
                        e.participants.remove(userID);
                      else
                        e.participants.add(userID!);
                      db.updateEvent(e);
                      setState(() {});
                    },
                    child: joined ? Text('Unjoin') : Text('join'),
                  );
                }),
              ],
            ),
          );
        });
  }
}

//https://api.flutter.dev/flutter/material/TextField-class.html
//https://api.flutter.dev/flutter/widgets/Form-class.html
//https://api.flutter.dev/flutter/material/TextFormField-class.html
//https://api.flutter.dev/flutter/widgets/FormField-class.html
//https://docs.flutter.dev/cookbook/forms/validation
class OrganizeScreen extends StatefulWidget {
  @override
  State<OrganizeScreen> createState() => _OrganizeScreenState();
}

class _OrganizeScreenState extends State<OrganizeScreen> {
  String? name;
  String? description;
  DateTime? orgDate;
  final List<String> beforePictures = [];
  final List<String> picturesToUpload = [];
  DocumentReference<Object?>? location;
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Organize'),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              Expanded(
                child: ListView(
                  children: [
                    TextButton(
                      onPressed: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime(DateTime.now().year + 10, 12, 31));
                        var time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: 0, minute: 0));
                        setState((() {
                          orgDate = DateTime(date!.year, date.month, date.day,
                              time!.hour, time.minute);
                        }));
                      },
                      child: ListTile(
                        title: Text('Time and date'),
                        trailing:
                            Text(orgDate != null ? orgDate.toString() : ''),
                      ),
                    ),
                    Divider(),
                    TextButton(
                      onPressed: () {},
                      child: ListTile(
                        title: Text('Choose location'),
                        trailing: Text('Cultuurtuinlaan 23'),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Name of event',
                        ),
                        onSaved: (String? value) {
                          name = value;
                        },
                        validator: (String? value) {
                          return (value == null || value.isEmpty)
                              ? 'Event must have a name.'
                              : null;
                        },
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        onSaved: (String? value) {
                          description = value;
                        },
                        validator: (String? value) {
                          return (value == null || value.isEmpty)
                              ? 'Event must have a description.'
                              : null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLength: null,
                        maxLines: null,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakePictureScreen(
                              cameraCallback: (path) =>
                                  setState(() => beforePictures.add(path))),
                        ),
                      ),
                      child: ListTile(
                        title: Text('Photo'),
                        leading: const Icon(Icons.camera_alt),
                      ),
                    ),
                    Divider(),
                    Container(
                        height: 200,
                        child: PageView.builder(
                            itemCount: beforePictures.length,
                            itemBuilder: (context, index) =>
                                Image.file(File(beforePictures[index])))),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    print('sending');
                    if (_formKey.currentState!.validate()) {
                      if (beforePictures.length < 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('A photo is necessary')),
                        );
                        return;
                      }
                      if (orgDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Specify the time and date')),
                        );
                        return;
                      }
                      _formKey.currentState!.save();

                      //tempory location randomly taken from the database
                      location = FirebaseFirestore.instance
                          .collection('Locations')
                          .doc();

                      for (var imagePath in beforePictures) {
                        picturesToUpload
                            .add(await db.uploadImage(File(imagePath)));
                      }
                      Event e = Event(
                          name!,
                          'TEST UPLOAD FROM APP: ' + description!,
                          false,
                          true,
                          DateTime.now(),
                          orgDate!,
                          [userID!],
                          [],
                          picturesToUpload,
                          [],
                          0,
                          location!);
                      db.addEvent(e);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Send')),
            ])));
  }
}

class StatisticsScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics')),
      body: Center(
        child: Text(
          'Statistics',
          textScaleFactor: 4,
        ),
      ),
    );
  }
}

//TODO Finish WrapUpScreen
//TODO WrapUp before orgdate is equal to cancel?
class WrapUpScreen extends StatelessWidget {
  Event e;
  WrapUpScreen(this.e);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wrap up')),
      body: Center(
        child: Text(
          'Wrap up',
          textScaleFactor: 4,
        ),
      ),
    );
  }
}

class UnreachableScreen extends StatelessWidget {
  UnreachableScreen();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unreachable')),
      body: Center(
        child: Text(
          'Unreachable',
          textScaleFactor: 4,
        ),
      ),
    );
  }
}

class LocTypeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db.getLTs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }
          var docs = snapshot.data?.docs;
          return ListView(
            padding: const EdgeInsets.only(top: 20.0),
            // 2
            children: docs!.map((data) => LocTypeItem(context, data)).toList(),
          );
        });
  }
}

Widget LocTypeItem(BuildContext context, DocumentSnapshot snapshot) {
  // 4
  final lt = LocationType.fromSnapshot(snapshot);
  return ListTile(
    title: Text(lt.name),
    subtitle: Text(lt.id!),
  );
}

class LocList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db.getLocs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }
          var docs = snapshot.data?.docs;
          return ListView(
            padding: const EdgeInsets.only(top: 20.0),
            // 2
            children: docs!.map((data) => LocItem(context, data)).toList(),
          );
        });
  }
}

Widget LocItem(BuildContext context, DocumentSnapshot snapshot) {
  // 4
  final loc = Location.fromSnapshot(snapshot);
  return ListTile(
      title:
          Text("GEO: ${loc.geo.latitude}, ${loc.geo.longitude}, ID: ${loc.id}"),
      subtitle: Text("LT: ${loc.type.path}"));
}

class EventList extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  EventList(this.stream);

  @override
  Widget build(BuildContext context) {
    // ^ This is Future<Image>, just pass to widget
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }
          var docs = snapshot.data?.docs;
          return ListView.builder(
              itemCount: docs!.length,
              itemBuilder: (context, index) =>
                  EventTile(Event.fromSnapshot(docs[index])));
        });
  }
}

class ClosedEventList extends StatelessWidget {
  final Stream<QuerySnapshot> stream;
  ClosedEventList(this.stream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LinearProgressIndicator();
          }
          var docs = snapshot.data?.docs;
          return PageView.builder(
              itemCount: docs!.length,
              itemBuilder: (context, index) =>
                  EventTile(Event.fromSnapshot(docs[index])));
        });
  }
}

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
                mapType: MapType.hybrid,
                markers: {
                  Marker(alpha: 1, position: loc, markerId: MarkerId("example"))
                },
                initialCameraPosition: CameraPosition(
                  target: loc,
                  bearing: 0,
                  tilt: 0,
                  zoom: 20,
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
                label: Text('To the lake!'),
                icon: Icon(Icons.directions_boat),
              ),
            );
          }
          return LinearProgressIndicator();
        });
  }
}
