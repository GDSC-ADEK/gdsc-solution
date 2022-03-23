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
                  ? db.getOrganizedEvents(state.user!.uid)
                  : db.getJoinedEvents(state.user!.uid))));
        } else {
          retwidget.add(
            Text(
              'Open events!',
              textScaleFactor: 1.5,
            ),
          );
          retwidget.add(Expanded(child: EventList(db.getOpenEvents())));
          retwidget.add(Divider());
          retwidget.add(
            Text(
              'Closed events!',
              textScaleFactor: 1.5,
            ),
          );
          retwidget.add(Container(
              height: 80,
              child: Expanded(child: ClosedEventList(db.getClosedEvents()))));

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
              //Use popUntil LoginScreen
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
  }
  final Event e;
  Widget build(BuildContext context) {
    var user = Provider.of<MyAppState>(context, listen: false)._user;
    print(user!.uid);
    final pictureToDisplay =
        e.complete ? e.afterPictures[0] : e.beforePictures[0];
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
                        EventPicturePages(e, before: !e.complete),
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('back'))
                      ]))),
          child: dbPicture(pictureToDisplay)),
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
                EventPicturePages(e, before: !e.complete),
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

//https://api.flutter.dev/flutter/material/TextField-class.html
//https://api.flutter.dev/flutter/widgets/Form-class.html
//https://api.flutter.dev/flutter/material/TextFormField-class.html
//https://api.flutter.dev/flutter/widgets/FormField-class.html
class OrganizeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Organize'),
        ),
        body: Form(
            child: ListView(
          children: [
            //https://pub.dev/packages/table_calendar
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.calendar_view_day),
                hintText: '22-3-2022?',
                labelText: 'Time and date',
              ),
              onSaved: (String? value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String? value) {
                return (value != null && value.contains('@'))
                    ? 'Do not use the @ char.'
                    : null;
              },
            )
          ],
        )));
  }
}

/*
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
*/

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
          /*return ListView(
            children: docs!
                .map((data) => EventTile(Event.fromSnapshot(data)))
                .toList(),
          );*/
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
          /*return PageView(
            controller: PageController(),
            children: docs!.map((data) {
              return EventTile(Event.fromSnapshot(data));
            }).toList(),
          );*/
        });
  }
}
