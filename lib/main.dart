/*
less firebase-debug.log -> https://stackoverflow.com/questions/63995958/firebase-init-functions-returns-403-caller-does-not-have-permission
flutter build apk -> https://docs.flutter.dev/release/breaking-changes/kotlin-version
https://firebase.google.com/codelabs/firebase-get-to-know-flutter#0
https://firebase.flutter.dev/docs/auth/usage
https://firebase.flutter.dev/docs/auth/social/
*/

//python -m http.server 8000
//import 'dart:html';

import 'package:flutter/material.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'firebase_options.dart';
import "locationtype.dart";

void main() async {
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
  await FirebaseAuth.instance.signInAnonymously();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) => MaterialApp(home: EventScreen());
}

class EventScreen extends StatefulWidget {
  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  bool isNGO = false;
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
            TextButton(
              onPressed: () {
                setState(() {
                  isNGO = !isNGO;
                });
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text('Toggle NGO'),
              ),
            ),
          ],
        ),
      ),
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
                for (int i = 0; i < 30; i++) EventTile(isNGO),
              ],
            ),
          ),
          LocationsList(),
          // LoctypeList(),
          RolesList(),
          // EventsList(),
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
                child: Container(
                  height: 60,
                  child: !isNGO
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
          )
        ],
      ),
    );
  }
}

class EventTile extends StatefulWidget {
  bool isNGO;
  EventTile(this.isNGO);
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
                widget.isNGO,
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
  final bool isNGO;
  EventDetail(
      this.name,
      this.short_message,
      this.date,
      this.max_attendees,
      this.number_of_signups,
      this.location,
      this.phone_number,
      this.joined,
      this.isNGO);

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
          TextButton(
            onPressed: () {},
            child: isNGO
                ? Text('Wrap up')
                : (joined ? Text('Unjoin') : Text('Join')),
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
class RolesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirestoreBuilder<RoleQuerySnapshot>(
        ref: roleRefs,
        builder: (context, AsyncSnapshot<RoleQuerySnapshot> snapshot,
            Widget? child) {
          if (snapshot.hasError) return Text('Something went wrong!');
          if (!snapshot.hasData) return Text('Loading roles...');

          // Access the QuerySnapshot
          RoleQuerySnapshot querySnapshot = snapshot.requireData;
          print(querySnapshot.docs[0].data);

          return ListView.builder(
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              // Access the User instance
              Role role = querySnapshot.docs[index].data;
              return Text('Role name: ${role.name}, members ${role.members}');
            },
          );
        });
  }
}

class LocationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirestoreBuilder<LocationQuerySnapshot>(
        ref: locRefs,
        builder: (context, AsyncSnapshot<LocationQuerySnapshot> snapshot,
            Widget? child) {
          if (snapshot.hasError) return Text('Something went wrong!');
          if (!snapshot.hasData) return Text('Loading locations...');

          // Access the QuerySnapshot
          LocationQuerySnapshot querySnapshot = snapshot.requireData;
          print(querySnapshot.docs[0].data);

          return ListView.builder(
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              // Access the User instance
              Location loc = querySnapshot.docs[index].data;
              return Text('Location geo: ${loc.loc}, type:${loc.type} ');
            },
          );
        });
  }
}

class LoctypeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirestoreBuilder<LocationTypeQuerySnapshot>(
        ref: LTRef,
        builder: (context, AsyncSnapshot<LocationTypeQuerySnapshot> snapshot,
            Widget? child) {
          if (snapshot.hasError) return Text('Something went wrong!');
          if (!snapshot.hasData) return Text('Loading locationtypes...');

          // Access the QuerySnapshot
          LocationTypeQuerySnapshot querySnapshot = snapshot.requireData;
          print(querySnapshot.docs[0].data);

          return ListView.builder(
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              // Access the User instance
              LocationType ltype = querySnapshot.docs[index].data;
              return Text('LT name: ${ltype.name}');
            },
          );
        });
  }
}

class EventsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirestoreBuilder<EventQuerySnapshot>(
        ref: eventRefs,
        builder: (context, AsyncSnapshot<EventQuerySnapshot> snapshot,
            Widget? child) {
          if (snapshot.hasError) return Text('Something went wrong!');
          if (!snapshot.hasData) return Text('Loading events...');

          // Access the QuerySnapshot
          EventQuerySnapshot querySnapshot = snapshot.requireData;
          print(querySnapshot.docs[0].data);

          return ListView.builder(
            itemCount: querySnapshot.docs.length,
            itemBuilder: (context, index) {
              // Access the User instance
              Event event = querySnapshot.docs[index].data;
              return Text('LT name: ${event.name}');
            },
          );
        });
  }
}
