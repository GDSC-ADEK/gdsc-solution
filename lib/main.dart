//python -m http.server 8000
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//without trailing zeros
String doubleToString(double x) {
  var s = '$x';
  if (s.toString().endsWith('.0')) return s.split('.')[0];
  else return s;
}

void main() {
    runApp(
        ChangeNotifierProvider(
            create: (context) => AppState(),
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Consumer<AppState>(
                    builder: (context, state, child) => Scaffold(
                        appBar: AppBar(
                            title: Text(state.currentScreenTitle()),
                        ),
                        body: state.currentScreen(),
                    ),
                ),
            ),
        ),
    );
}

class AppState extends ChangeNotifier {
    int currentScreenIndex = 0;

    AppState() {
        currentScreenIndex = 0;
    }

    Widget currentScreen() {
        switch(currentScreenIndex) {
            case 0: return LoginScreen();
            case 1: return SecondScreen();
            /*return TextButton(
                onPressed: () {
                    switchScreen();
                },
                child: const Text('Switch',),
            );*/
            default: return LostScreen();
        }
    }

    String currentScreenTitle() {
        switch(currentScreenIndex) {
            case 0: return 'Login screen';
            case 1: return 'Second screen';
            default: return 'Lost screen';
        }
    }

    void switchScreen() {
        currentScreenIndex = 1 - currentScreenIndex;
        notifyListeners();
    }
}

class LostScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Center(
            child: Text(
                'Got lost?',
                style: const TextStyle(fontSize: 20),
            ),
        );
    }
}

class LoginScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Center(
            child: Container(
                //width: 200,
                padding: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        const TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Username',
                            ),
                        ),
                        const SizedBox(height: 30),
                        const TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Password',
                            ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
                            onPressed: () {
                                Provider.of<AppState>(context, listen: false).switchScreen();
                            },
                            child: const Text('Login'),
                        ),
                    ],
                ),
            ),
        );
    }
}

class SecondScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return (
            Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Text(
                        'Clean up days',
                        style: const TextStyle(fontSize: 20),
                    ),
                    Expanded(
                        child: Container(
                            color: Colors.amber[600],
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: ListView(
                                children: List.generate(30, (i) => Card(
                                    child: TextButton(
                                            onPressed: () {
                                                Provider.of<AppState>(context, listen: false).switchScreen();
                                            },
                                            child: Container(
                                                width: double.infinity,
                                                height: 100,
                                                child: Text("Item ${i+1}"),
                                            ),
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                        'Finished clean up days',
                        style: const TextStyle(fontSize: 20),
                    ),
                    Expanded(
                        child: Container(
                            color: Colors.blue[600],
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: ListView(
                                children: List.generate(30, (i) => Card(
                                        child: Container(
                                            height: 100,
                                            child: Text("Item ${i+1}"),
                                        ),
                                    ),
                                ),
                            ),
                        ),
                    ),
                    const SizedBox(height: 30),
                ],
            )
        );
    }
}