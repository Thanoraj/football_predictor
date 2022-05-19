import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  TextEditingController accelerationController = TextEditingController();
  TextEditingController speedController = TextEditingController();
  TextEditingController angleController = TextEditingController();
  bool showResults = true;

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
    var uri = Uri.https(url, '/predict_goal', {
      "accelaration": acceleration.toString(),
      'speed': speed.toString(),
      'angle': angle.toString(),
    });
    var response = await http.get(uri, headers: {
      "Accept": "application/json",
      "Access-Control-Allow-Origin": "*"
    });
    var decodedResponse = await jsonDecode(response.body);
    result = await decodedResponse;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Stack(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 500,
                child: ListView(
                  children: [
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        "⚽ Football Predictor",
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
                            controller: accelerationController,
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              double? newVal = double.tryParse(val);
                              if (newVal == null && val.isNotEmpty) {
                                accelerationController.text =
                                    acceleration.toString();
                                accelerationController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: accelerationController
                                            .text.length));
                              } else {
                                acceleration = double.tryParse(val) ?? 0;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
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
                        Text(
                          "  m/s\u00B2",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          child: Text(
                            "Speed: ",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          width: 150,
                        ),
                        SizedBox(
                          child: TextField(
                            controller: speedController,
                            onChanged: (val) {
                              double? newVal = double.tryParse(val);
                              if (newVal == null && val.isNotEmpty) {
                                speedController.text = speed.toString();
                                speedController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: speedController.text.length));
                              } else {
                                speed = double.tryParse(val) ?? 0;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
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
                        Text(
                          "  m/s",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          child: Text(
                            "Angle: ",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          width: 150,
                        ),
                        SizedBox(
                          child: TextField(
                            controller: angleController,
                            onChanged: (val) {
                              double? newVal = double.tryParse(val);
                              if (newVal == null && val.isNotEmpty) {
                                angleController.text = angle.toString();
                                angleController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset: angleController.text.length));
                              } else {
                                angle = double.tryParse(val) ?? 0;
                              }
                            },
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
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
                        Text(
                          "  degree",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green[700]),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10),
                            child: Text("Predict"),
                          ),
                          onPressed: () {
                            //predict();
                            showResults = true;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    /*Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        result,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 50),
                      ),
                    )),*/
                  ],
                ),
              ),
            ]),
        if (showResults)
          GestureDetector(
            onTap: () {
              showResults = false;
              setState(() {});
            },
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Material(
                  color: Colors.grey[700],
                  elevation: 5,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    margin: EdgeInsets.all(5),
                    width: 350,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        result,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ]),
    );
  }
}
