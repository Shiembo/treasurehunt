import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class TreasureHuntScreen extends StatefulWidget {
  const TreasureHuntScreen({super.key});

  @override
  _TreasureHuntScreenState createState() => _TreasureHuntScreenState();
}

class _TreasureHuntScreenState extends State<TreasureHuntScreen> {
  List<Map<String, dynamic>> treasureLocations = [];

  String _treasureFound = "";
  String _treasureHint = "";

  @override
  void initState() {
    super.initState();
    try {
      _downloadTreasureLocations();
    } catch (e) {
      print(e);
    }
  }

  final firestoreInstance = FirebaseFirestore.instance;

  void _downloadTreasureLocations() async {
    // final querySnapshot =
    //     await FirebaseFirestore.instance.collection('treasurehuntone').get();
    // print(querySnapshot);
    // print(querySnapshot.toString());
    // querySnapshot.docs.forEach((DocumentSnapshot document) {
    //   print(document.data);
    //   treasureLocations.add(document.data as Map<String, dynamic>);
    // });

    firestoreInstance.collection("treasurehuntone").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        print(result.data());
        //final jsonData = JsonDecoder(result.data());
        print(result.data()['lat number']);

        if (result.data()['lat number'].toString() == '52.0897654' &&
            result.data()['long number'].toString() == '-2.9764478') {
          print('hurray ${result.data()['hint name']} won the treasure hunt');
        }

        // firestoreInstance
        //     .collection("users")
        //     .where(
        //       'lat number',
        //     )
        //     .get()
        //     .then((value) => null);
      });
    });

    // firestoreInstance
    //     .collection("users")
    //     .where("address.country", isEqualTo: "USA")
    //     .where(
    //       'lat number',
    //     )
    //     .snapshots()
    //     .listen((result) {
    //   result.docs.forEach((result) {
    //     print(result.data());
    //   });
    // });
  }

  void _checkForTreasure() async {
    print('hello');
    final currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    for (Map<String, dynamic> location in treasureLocations) {
      final distanceInMeters = Geolocator.distanceBetween(
          currentLocation.latitude,
          currentLocation.longitude,
          location["latitude"],
          location["longitude"]);
      print(distanceInMeters.toString() + 'Hello');
      if (distanceInMeters < 100) {
        setState(() {
          _treasureFound =
              "Treasure found at ${location["latitude"]}, ${location["longitude"]}";
          _treasureHint = location["hint"];
        });
        break;
      } else {
        setState(() {
          _treasureFound = "No treasure found nearby";
          _treasureHint = "";
        });
      }
      print(distanceInMeters);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Treasure Hunt App")),
        body: Column(children: <Widget>[
          Expanded(child: Center(child: Text(_treasureFound))),
          Expanded(child: Center(child: Text(_treasureHint))),
          ElevatedButton(
              onPressed: () => _checkForTreasure(),
              child: Text("Check for treasure"))
        ]));
  }
}
