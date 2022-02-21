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
        MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                appBar: AppBar(
                    title: const Text('Login screen'),
                ),
                body: Center(
                    child: Container(
                        width: 200,
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
                                    onPressed: () {},
                                    child: const Text('Login'),
                                ),
                            ],
                        ),
                    ),
                ),
            ),
        ),
    );
}