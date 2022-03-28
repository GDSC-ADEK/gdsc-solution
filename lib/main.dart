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
import 'map_widgets.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'camera.dart';
import 'MyNotification.dart';

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
String? email;

setupNotificationHandlers(BuildContext context) {
  MyNotification().addHandler('WrapUp', (arg) async {
    var e = Event.fromSnapshot(await db.getEventByID(arg));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => WrapUpScreen(e)));
  });
  MyNotification().addHandler('Detail', (arg) async {
    var e = Event.fromSnapshot(await db.getEventByID(arg));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EventDetail(e)));
  });
}

setupNotifications() {
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user != null) {
      db
          .getEvents(completed: false, published: true, organizer: user.uid)
          .listen((event) {
        for (var doc in event.docs) {
          var e = Event.fromSnapshot(doc);
          var dateTime = DateTime.now();
          var dateTime2 =
              DateTime(e.orgDate.year, e.orgDate.month, e.orgDate.day - 1, 12);
          var dateTime3 = e.orgDate.add(Duration(hours: 3));
          if (dateTime.isBefore(dateTime2)) {
            MyNotification().schedule(
                title: e.name,
                body: e.orgDate.toString(),
                dateTime: dateTime2,
                payload: 'Detail ${e.id}');
          } else if (dateTime.isBefore(e.orgDate)) {
            MyNotification().schedule(
                title: e.name,
                body: e.orgDate.toString(),
                payload: 'Detail ${e.id}');
          }
          //Ik gebruik voor deze twee ook de detail handler want WrapUpScreen heeft geen info over de event
          if (dateTime.isBefore(dateTime3)) {
            MyNotification().schedule(
                title: 'Time to wrap up ${e.name}?',
                body: e.orgDate.toString(),
                dateTime: dateTime3,
                payload: 'Detail ${e.id}');
          } else {
            MyNotification().schedule(
                title: 'Time to wrap up ${e.name}?',
                body: e.orgDate.toString(),
                payload: 'Detail ${e.id}');
          }
        }
      });
      db
          .getEvents(completed: false, published: true, participant: user.uid)
          .listen((event) {
        for (var doc in event.docs) {
          var e = Event.fromSnapshot(doc);
          var dateTime = DateTime.now();
          var dateTime2 =
              DateTime(e.orgDate.year, e.orgDate.month, e.orgDate.day - 1, 12);
          if (dateTime.isBefore(dateTime2)) {
            MyNotification().schedule(
                title: e.name,
                body: e.orgDate.toString(),
                dateTime: dateTime2,
                payload: 'Detail ${e.id}');
          } else if (dateTime.isBefore(e.orgDate)) {
            MyNotification().schedule(
                title: e.name,
                body: e.orgDate.toString(),
                payload: 'Detail ${e.id}');
          }
        }
      });
    }
  });
}

class MyAppState extends ChangeNotifier {
  bool _myevents = false;
  bool _RequestNGO = false;

  bool get myevents => _myevents;
  set myevents(bool value) {
    _myevents = value;
    notifyListeners();
  }

  bool get RequestNGO => _RequestNGO;
  set RequestNGO(bool value) {
    _RequestNGO = value;
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
    await GoogleSignIn().disconnect();
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
  LoginScreen() {
    setupNotifications();
  }
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool RequestNGO = false;
  Widget build(BuildContext context) {
    setupNotificationHandlers(context);
    return Consumer<MyAppState>(
      builder: (context, state, _) => StreamBuilder(
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
            db.snapshotsRoleByID('organizer').listen((event) {
              var value = Role.fromSnapshot(event).members.contains(user.uid);
              if (state.RequestNGO != value) state.RequestNGO = value;
            });
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
                if (RequestNGO && !r.members.contains(userID)) {
                  String? encodeQueryParameters(Map<String, String> params) {
                    return params.entries
                        .map((e) =>
                            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                        .join('&');
                  }
            var user = snapshot.data;
            if (user != null) {
              db.snapshotsRoleByID('organizer').listen((event) {
                var value = Role.fromSnapshot(event).members.contains(user.uid);
                if (state.RequestNGO != value) state.RequestNGO = value;
              });
              userID = user.uid;
              email = user.email;
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
                  if (RequestNGO && !r.members.contains(userID)) {
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
                        'subject': 'Request NGO status',
                        'body':
                            'Hello, I am ${user.email} and I would like to request NGO status.\nUSER ID: ${user.uid}'
                      }),
                    );
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'uvsgdsc@gmail.com',
                    query: encodeQueryParameters(<String, String>{
                      'subject': 'Request NGO status',
                      'body':
                          'Hello, I am ${user.displayName} and I would like to request NGO status.\nUSER ID: ${user.uid}'
                    }),
                  );

                  launch(emailLaunchUri.toString());
                  return EventScreen();
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
                    child: Text('Sign in'),
                    onPressed: () async {
                      //Ik moet gaan kijken hoe try catch blocks werken
                      //TODO try and catch werken niet met Future zonder await gerbuik in de plaats callbacks
                      try {
                        /*
                          Canceling google sign in causese exception
                          Apparently only a problem in release mode
                          https://stackoverflow.com/questions/59561486/canceling-google-sign-in-cause-an-exception-in-flutter
                          */
                        await state.signInWithGoogle();
                        //.signInAnonymously();
                      } on FirebaseAuthException catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Text('Login error'),
                                content: Text(e.code)));
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Text('Request NGO status'),
                    onPressed: () async {
                      try {
                        await state.signInWithGoogle();
                        //.signInAnonymously();
                      } on FirebaseAuthException catch (e) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                title: Text('Login error'),
                                content: Text(e.code)));
                      }
                      state.RequestNGO = true;
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EventScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EventScreenDrawer(),
      appBar: AppBar(title: Consumer<MyAppState>(builder: (context, state, _) {
        String my_text = (state.RequestNGO) ? "Organized" : "Joined";
        return Text(
          state.myevents ? '$my_text events' : 'All events',
          textScaleFactor: 1.5,
        );
      })),
      body: Consumer<MyAppState>(builder: (context, state, _) {
        final retwidget = <Widget>[];
        retwidget.add(SizedBox(height: 20));
        if (state.myevents) {
          if (state.RequestNGO) {
            retwidget.add(Expanded(
              child: EventList(db.getEvents(organizer: userID)),
            ));
          } else {
            retwidget.add(Expanded(
              child: EventList(db.getEvents(participant: userID)),
            ));
          }
        } else {
          retwidget.add(
            Text(
              'Open events',
              textScaleFactor: 1.25,
            ),
          );
          retwidget.add(Expanded(
              child:
                  EventList(db.getEvents(completed: false, published: true))));
          retwidget.add(Divider());
          retwidget.add(
            Text(
              'Closed events',
              textScaleFactor: 1.25,
            ),
          );
          retwidget.add(Container(
              height: 170,
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
              child: Container(
                height: 60,
                child: !state.RequestNGO
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
          ],
        ));
        return Column(children: retwidget);
      }),
    );
  }
}

class EventScreenDrawer extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer',
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
                leading: Icon(Icons.exit_to_app),
                title: Text(
                  'Sign Out',
                ),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Provider.of<MyAppState>(context, listen: false).myevents =
                    false;
              },
              child: ListTile(
                leading: Icon(Icons.event),
                title: Text('All events'),
              ),
            ),
            Divider(),
            Consumer<MyAppState>(
              builder: (context, state, _) => TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  state.myevents = true;
                },
                child: ListTile(
                  leading: Icon(Icons.event_available),
                  title: Text(
                      '${state.RequestNGO ? "Organized" : "Joined"} events'),
                ),
              ),
            ),
            Divider(),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RecycleMap()));
              },
              child: ListTile(
                title: Text('Recycle Bins'),
                leading: Icon(Icons.map),
              ),
            ),
          ],
        ),
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
          ? Colors.lightBlueAccent
          : (e.participants.contains(userID) ? Colors.lightGreenAccent : null),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: (() => Navigator.push(context,
              MaterialPageRoute(builder: (context) => EventDetail(e)))),
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            ListTile(
              leading: Container(child: dbPicture(pictureToDisplay), width: 75,height: 75, padding: EdgeInsets.all(0),),
              title: Text(
                  '${e.name} on ${DateFormat("dd MMM yy H:mm").format(e.orgDate)}'),
              subtitle: Text((e.description.length < 150)
                  ? '${e.description}'
                  : e.description.substring(0, 149) + "..."),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(width: 8),
                Icon(Icons.people_alt),
                Text("${e.participants.length}"),
                const SizedBox(width: 8),
              ],
            ),
          ]),
        ),
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


  Widget build(BuildContext context) {
    //Event e = Event.fromSnapshot(await db.getEventByID(widget.e.id));
    return StreamBuilder(
        stream: db.snapshotsEventByID(this.widget.e.id!),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Event ${this.widget.e.id} does not exist");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
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
                      ListTile(
                          leading: Icon(Icons.date_range),
                          title: Text(
                              '${DateFormat("dd MMM yy H:mm").format(e.orgDate)}')),
                      ListTile(
                          leading: Icon(Icons.people),
                          title: Text(
                              '${e.participants.length} ${(e.participants.length == 1) ? "person" : "people"} joined')),
                      ListTile(
                        title: Text('$email'),
                        leading: Icon(Icons.email),
                      ),
                    ],
                  ),
                ),
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

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return RaisedButton(
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                      appBar:
                                          AppBar(title: Text("Back to event")),
                                      body: EventMap(e.location.id))));
                        },
                        child: ListTile(
                          title: Text("View location"),
                        ),
                      );
                    }

                    return LinearProgressIndicator();
                  },
                ),
                Consumer<MyAppState>(builder: (context, state, _) {
                  bool joined = e.participants.contains(userID);
                  if (state.RequestNGO && !joined)
                    return (e.organizers.contains(userID) &&
                            e.complete == false)
                        ? ElevatedButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WrapUpScreen(e))),
                            child: Text('Wrap up'),
                          )
                        : Container();
                  return e.complete
                      ? Container()
                      : ElevatedButton(
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
  GeoPoint loc = GeoPoint(0, 0);
  final _formKey = GlobalKey<FormState>();
  void locationCallback(GeoPoint geo) {
    setState(() {
      loc = geo;
    });
  }

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
                        if (date != null && time != null)
                          setState((() {
                            orgDate = DateTime(date.year, date.month, date.day,
                                time.hour, time.minute);
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(
                                    appBar: AppBar(
                                        title: Text("Back to event creation")),
                                    body:
                                        LocationPickerMap(locationCallback))));
                      },
                      child: ListTile(
                        title: Text(((loc.latitude == 0) && (loc.latitude == 0))
                            ? "Pick location"
                            : "Select new location"),
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
                          description!,
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
  List<String> afterPics = [];
  List<String> picturesToUpload = [];
  WrapUpScreen(this.e);
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('wrap up'),
        ),
        body: Form(
            key: _formKey,
            child: Column(children: [
              Expanded(
                child: ListView(
                  children: [
                    Divider(),
                    ListTile(
                      title: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'How much garbage did you collect? (kg)',
                        ),
                        onSaved: (String? value) {
                          // POTENTIAL ERROR!!!!!!!!!!!!!!!!!!
                          e.complete = true;
                          e.garbageCollected = double.parse(value!);
                          db.updateEvent(e);
                        },
                        validator: (String? value) {
                          return (value == null || value.isEmpty)
                              ? 'Event must have some garbage collected.'
                              : null;
                        },
                        keyboardType: TextInputType.number,
                        maxLength: null,
                        maxLines: null,
                      ),
                    ), // num garbage collected
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TakePictureScreen(
                              cameraCallback: (path) => afterPics.add(path)),
                        ),
                      ),
                      child: ListTile(
                        title: Text('Photo'),
                        leading: const Icon(Icons.camera_alt),
                      ),
                    ), // add after pictures
                    Divider(),
                    Container(
                        height: 200,
                        child: PageView.builder(
                            itemCount: afterPics.length,
                            itemBuilder: (context, index) => Image.file(
                                File(afterPics[index])))), // pictures shown
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    // Validate returns true if the form is valid, or false otherwise.
                    print('sending');
                    if (_formKey.currentState!.validate()) {
                      if (afterPics.length < 1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('A photo is necessary')),
                        );
                        return;
                      }
                      if (e.complete == false) {
                        e.complete = true;
                        db.updateEvent(e);
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //       content:
                        //           Text('The event must be marked complete')),
                        // );
                        return;
                      }
                      _formKey.currentState!.save();

                      for (var imagePath in afterPics) {
                        db.uploadAfterImgToEvent(e, File(imagePath));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text('update')),
            ])));
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
