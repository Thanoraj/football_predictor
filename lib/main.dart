import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:football_predictor/secrets.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: keys);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Football Predictor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
    getURL();
  }

  String url = '';
  String result = '';
  double acceleration = 0, speed = 0, angle = 0;
  getURL() {
    FirebaseFirestore.instance
        .collection("footballPredictor")
        .doc("Url")
        .get()
        .then((value) {
      url = value.data()!['Url'];
    });
  }

  predict() async {
    print(url);
    var uri = await Uri.https(url, '/predict_goal', {
      "accelaration": acceleration.toString(),
      'speed': speed.toString(),
      'angle': angle.toString(),
    });
    print(uri);
    var response = await http.get(uri, headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });
    print('sent');
    var decodedResponse = await jsonDecode(response.body);
    result = await decodedResponse;
    print(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 450,
              child: ListView(
                children: [
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      "Football Predictor",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  )),
                  Row(
                    children: [
                      const SizedBox(
                        child: Text(
                          "Acceleration: ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        width: 150,
                      ),
                      SizedBox(
                        child: TextField(
                          onChanged: (val) {
                            acceleration = double.parse(val);
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        width: 250,
                      ),
                      // Text(
                      //   "m/s",
                      //   style: TextStyle(color: Colors.white, fontSize: 20),
                      // ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        child: Text(
                          "Speed: ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        width: 150,
                      ),
                      SizedBox(
                        child: TextField(
                          onChanged: (val) {
                            speed = double.parse(val);
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        width: 250,
                      ),
                      // Text(
                      //   "m/s",
                      //   style: TextStyle(color: Colors.white, fontSize: 20),
                      // ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        child: Text(
                          "Angle: ",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        width: 150,
                      ),
                      SizedBox(
                        child: TextField(
                          onChanged: (val) {
                            angle = double.parse(val);
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        width: 250,
                      ),
                      // Text(
                      //   "degree",
                      //   style: TextStyle(color: Colors.white, fontSize: 20),
                      // ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10),
                          child: Text("Predict"),
                        ),
                        onPressed: () {
                          predict();
                        },
                      ),
                    ),
                  ),
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40.0),
                    child: Text(
                      result,
                      style: TextStyle(color: Colors.white, fontSize: 50),
                    ),
                  )),
                ],
              ),
            ),
          ]),
    );
  }
}

// chrome.exe --user-data-dir="C://Chrome dev session" --disable-web-security
