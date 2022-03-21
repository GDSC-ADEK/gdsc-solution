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

import 'package:google_sign_in/google_sign_in.dart';

import 'camera.dart';

var imagelink =
    "https://static.rondreis.nl/rondreis-storage-production/media-3686-conversions-paramaribo-xxl-webp/w670xh449/eyJidWNrZXQiOiJyb25kcmVpcy1zdG9yYWdlLXByb2R1Y3Rpb24iLCJrZXkiOiJtZWRpYVwvMzY4NlwvY29udmVyc2lvbnNcL3BhcmFtYXJpYm8teHhsLndlYnAiLCJlZGl0cyI6eyJyZXNpemUiOnsid2lkdGgiOjY3MCwiaGVpZ2h0Ijo0NDl9fX0=";

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

class MyAppState extends ChangeNotifier {
  bool _isNGO = false;
  User? _user;
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

  User? get user => _user;

  MyAppState() {
    _init();
  }

  Future<void> _init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions
            .android); // TODO: change this to .currentPlatform later

    // We sign the user in anonymously, meaning they get a user ID without having
    // to provide credentials.
    //await FirebaseAuth.instance.signInAnonymously();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
    db = Fdatabase();
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
        child: MaterialApp(
          home: //LoginScreen()
              Consumer<MyAppState>(
            builder: (context, state, _) =>
                state.user != null ? EventScreen() : LoginScreen(),
          ),
        ),
      );
}

class LoginScreen extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            child: Text('Sign in'),
            onPressed: () {
              //Ik moet gaan kijken hoe try catch blocks werken
              try {
                Provider.of<MyAppState>(context, listen: false)
                    // .signInWithGoogle();
                    .signInAnonymously();
              } on FirebaseAuthException catch (e) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                        title: Text('Login error'), content: Text(e.code)));
              }
              /*FirebaseAuth.instance.authStateChanges().listen((value) =>
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EventScreen())));*/
            },
          ),
        ),
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
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Open events!',
            textScaleFactor: 1.5,
          ),
          // Expanded(child: LocList()),
          // Expanded(child: LocTypeList()),
          Expanded(child: EventList(db.getOpenEvents())),
          // Expanded(child: RolesList()),
          Divider(),
          Text(
            'Closed events!',
            textScaleFactor: 1.5,
          ),
          Container(
              width: double.infinity,
              height: 80,
              child: Expanded(child: ClosedEventList(db.getClosedEvents()))),
          Divider(),
          Row(
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
          )
        ],
      ),
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
              //Use popUntil LoginEcreen
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
              onPressed: !state.isNGO
                  ? null
                  : () {
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

class EventTile extends StatelessWidget {
  EventTile(this.e) {
    // 1 manier om images te halen,
    // call db.getImg on elements in afterpictures to get Future<Img>
    Future<String> furl = db.getImgUrl("afterPictures/check.webp");
    List<Future<String>> furls =
        e.beforePictures.map((e) => db.getImgUrl(e)).toList();
    var url = furl.then((value) => print(value));
    // var img = Image.network(url);
    //  2e manier, call db.getImgUrl to get Future<string>, which you then use
    // on Image.network
    // pass the value to Img.network to get Image
    Future<Image> imgg = db.getImg("afterPictures/uncheck.png");
    var imgg2 = db.getImg(e.beforePictures[0]);

    //3e manier: call db.getImgsFromEvent(event)
    // returnt {"before": List<Future<Img>>>, "after" : List<Future<Img>>>}
    Map<String, List<Future<Image>>> imagesFromEvent =
        db.getImgsFromEvent(this.e);
  }
  final Event e;
  Widget imagewidget = Image.network(imagelink);
  Widget build(BuildContext context) {
    var user = Provider.of<MyAppState>(context, listen: false)._user;
    print(user!.uid);
    return ListTile(
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
                        imagewidget,
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('back'))
                      ]))),
          child: imagewidget),
    );
  }
}

class EventDetail extends StatelessWidget {
  final Event e;
  final int max_attendees = 20;
  final String phone_number = '+5978855645';
  final bool joined = false;

  EventDetail(this.e);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(e.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Image.network(imagelink),
                ListTile(title: Text('Short message: ${e.description}')),
                ListTile(title: Text('Day organized: ${e.orgDate}')),
                ListTile(
                    title: Text('Max number of attendees: $max_attendees')),
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
                      print(e.location.id);
                      return Text(
                          "Document \"${e.location.id}\" does not exist");
                    }

                    if (snapshot.connectionState == ConnectionState.done) {
                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      return Text("Location: ${data['geo']}");
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
          Consumer<MyAppState>(
            builder: (context, state, _) => ElevatedButton(
              onPressed: () {},
              child: state.isNGO
                  ? Text('Wrap up')
                  : (joined ? Text('Unjoin') : Text('Join')),
            ),
          ),
        ],
      ),
    );
  }
}

class OrganizeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organize'),
      ),
      body: ListView(
        children: [
          //Here should be your own picture
          //Image.network(imagelink),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text('Choose time and date'),
              trailing: Text('22-3-2022'),
            ),
          ),
          Divider(),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text('Choose max number of attendees'),
              trailing: Text('20'),
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
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text('Write Message'),
              subtitle: Text('Will be sent in email to participants'),
            ),
          ),
          Divider(),
          TextButton(
            onPressed: () {},
            child: ListTile(
              title: Text('Phone number'),
              trailing: Text('+5978855645'),
            ),
          ),
          Divider(),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TakePictureScreen(),
              ),
            ),
            child: ListTile(
              title: Text('Photo'),
              leading: const Icon(Icons.camera_alt),
            ),
          ),
          Divider(),
        ],
      ),
    );
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
          return ListView(
            children: docs!
                .map((data) => EventTile(Event.fromSnapshot(data)))
                .toList(),
          );
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
          return PageView(
            controller: PageController(),
            children: docs!.map((data) {
              return EventTile(Event.fromSnapshot(data));
            }).toList(),
          );
        });
  }
}
