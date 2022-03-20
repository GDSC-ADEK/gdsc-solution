/*
less firebase-debug.log -> https://stackoverflow.com/questions/63995958/firebase-init-functions-returns-403-caller-does-not-have-permission
flutter build apk -> https://docs.flutter.dev/release/breaking-changes/kotlin-version
https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0
https://firebase.flutter.dev/docs/auth/usage
https://firebase.flutter.dev/docs/auth/social/

google sign in example -> https://github.com/flutter/plugins/blob/master/packages/google_sign_in/google_sign_in/example/lib/main.dart
*/

//python -m http.server 8000
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'database.dart';
import "models/location.dart";
import "models/locationtype.dart";
import 'models/events.dart';

import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  runApp(MyApp());
}

Fdatabase db = Fdatabase();

class MyAppState extends ChangeNotifier {
  bool _isNGO = false;
  User? _user;
  String? _error;

  bool get isNGO => _isNGO;

  set isNGO(bool value) {
    _isNGO = value;
    notifyListeners();
  }

  User? get user => _user;

  String? get error => _error;

  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  MyAppState() {
    _init();
  }

  Future<void> _init() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
    } catch (e, st) {
      print(e);
      print(st);
    }
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
          home: Consumer<MyAppState>(
            builder: (context, state, _) => state.error != null
                ? Center(child: Text(state.error!))
                : (state.user != null
                    ? EventScreen()
                    : Center(
                        child: TextButton(
                          child: Text('Sign in'),
                          onPressed: () {
                            try {
                              Provider.of<MyAppState>(context, listen: false)
                                  .signInWithGoogle();
                            } on FirebaseAuthException catch (e) {
                              state.error = e.code;
                            }
                          },
                        ),
                      )),
          ),
        ),
      );
}

class EventScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: EventScreenDrawer(),
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            'Open events!',
            textScaleFactor: 1.5,
          ),
          Expanded(
            child: ListView(
              children: [
                for (int i = 0; i < 30; i++) EventTile(),
              ],
            ),
          ),
          // Expanded(child: LocList()),
          // Expanded(child: LocTypeList()),
          Expanded(child: EventList()),
          // Expanded(child: RolesList()),
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
              Provider.of<MyAppState>(context, listen: false).signOut();
            },
            child: ListTile(
              title: Text('SignOut'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Open events'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Closed events'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: ListTile(
              title: Text('Favorite events'),
            ),
          ),
          Consumer<MyAppState>(
            builder: (context, state, _) => TextButton(
              onPressed: !state.isNGO
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
              child: ListTile(
                title: Text('My events'),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              var state = Provider.of<MyAppState>(context, listen: true);
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

class EventTile extends StatefulWidget {
  EventTile();

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  bool checked = false;

  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Latour'),
      subtitle: Text('Date: _______'),
      leading: Checkbox(
        value: checked,
        onChanged: (val) {
          setState(() {
            checked = val!;
          });
        },
      ),
      trailing: TextButton(
        child: Text('More'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => EventDetail(
                'Latour',
                'Come join us Lions Club and clean up our neighborhood',
                '22-3-2022',
                20,
                7,
                'Cultuurtuinlaan 23',
                '+5978855645',
                false,
              ),
            ),
          );
        },
      ),
    );
  }
}

class EventDetail extends StatelessWidget {
  final String name;
  final String short_message;
  final String date;
  final int max_attendees;
  final int number_of_signups;
  final String location;
  final String phone_number;
  final bool joined;

  EventDetail(
    this.name,
    this.short_message,
    this.date,
    this.max_attendees,
    this.number_of_signups,
    this.location,
    this.phone_number,
    this.joined,
  );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          ListTile(title: Text('Short message: $short_message')),
          ListTile(title: Text('Day organized: $date')),
          ListTile(title: Text('Max number of attendees: $max_attendees')),
          ListTile(
              title: Text('Current number of sign ups: $number_of_signups')),
          ListTile(title: Text('Location: $location')),
          ListTile(
            title: Text('Phone number lead: $phone_number'),
            subtitle: Text('(will get send to the participants)'),
          ),
          Consumer<MyAppState>(
            builder: (context, state, _) => TextButton(
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

// TODO README: https://firebase.flutter.dev/docs/firestore-odm/references
// read ^ to see widgets, reading, querying
// class RolesList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FirestoreBuilder<RoleQuerySnapshot>(
//         ref: roleRefs,
//         builder: (context, AsyncSnapshot<RoleQuerySnapshot> snapshot,
//             Widget? child) {
//           if (snapshot.hasError) return Text('roles: Something went wrong!');
//           if (!snapshot.hasData) return Text('Loading roles...');
//
//           // Access the QuerySnapshot
//           RoleQuerySnapshot querySnapshot = snapshot.requireData;
//           // print(querySnapshot.docs[0].data);  // DEBUG
//
//           return ListView.builder(
//             itemCount: querySnapshot.docs.length,
//             itemBuilder: (context, index) {
//               // Access the User instance
//               Role role = querySnapshot.docs[index].data;
//               return Text('Role name: ${role.name}, members ${role.members}');
//             },
//           );
//         });
//   }
// }
//
// class LocationsList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FirestoreBuilder<LocationQuerySnapshot>(
//         ref: locRefs,
//         builder: (context, AsyncSnapshot<LocationQuerySnapshot> snapshot,
//             Widget? child) {
//           if (snapshot.hasError){
//             print(snapshot.error);
//             return Text('locations: ${snapshot.error}');
//           }
//
//           if (!snapshot.hasData) return Text('Loading locations...');
//
//           // Access the QuerySnapshot
//           LocationQuerySnapshot querySnapshot = snapshot.requireData;
//           print(querySnapshot.docs[0].data);
//
//           return ListView.builder(
//             itemCount: querySnapshot.docs.length,
//             itemBuilder: (context, index) {
//               // Access the User instance
//               Location loc = querySnapshot.docs[index].data;
//               print("LOC = $loc");
//               return Text('Location geo: ${loc.geo}, type:${loc.type} ');
//             },
//           );
//         });
//   }
// }
//
// class LoctypeList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FirestoreBuilder<LocationTypeQuerySnapshot>(
//         ref: LTRef,
//         builder: (context, AsyncSnapshot<LocationTypeQuerySnapshot> snapshot,
//             Widget? child) {
//           if (snapshot.hasError){
//             print(snapshot.error);
//             return Text('locationtypes: Something went wrong!');
//           }
//
//           if (!snapshot.hasData) return Text('Loading locationtypes...');
//
//           // Access the QuerySnapshot
//           LocationTypeQuerySnapshot querySnapshot = snapshot.requireData;
//           // print(querySnapshot.docs[0].data); // DEBUG
//
//           return ListView.builder(
//             itemCount: querySnapshot.docs.length,
//             itemBuilder: (context, index) {
//               // Access the User instance
//               LocationType ltype = querySnapshot.docs[index].data;
//               return Text('LT name: ${ltype.name}');
//             },
//           );
//         });
//   }
// }

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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: db.getEvents(),
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
            children: docs!.map((data) => EventItem(context, data)).toList(),
          );
        });
  }
}

Widget EventItem(BuildContext context, DocumentSnapshot snapshot) {
  // 4
  final e = Event.fromSnapshot(snapshot);
  return ListTile(
      title: Text("Event( name:${e.name},\n"
          "published: ${e.publish},\n"
          "created: ${e.creationDate},\n"
          "organizers: ${e.organizers},\n"
          "collected: ${e.garbageCollected} \n"
          "loc: ${e.location.path})"),
      subtitle: Text("id: ${e.id!}"));
}
