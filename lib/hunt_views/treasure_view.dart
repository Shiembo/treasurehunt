import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haversine_distance/haversine_distance.dart' as hd;
import 'package:hunt/hunt_views/profile_view.dart';
import 'package:location/location.dart' as lc;
import 'package:share_plus/share_plus.dart';
import 'package:hunt/hunt_views/treasure_distance_view.dart';

class Treasure {
  double latitude;
  double longitude;
  String name;
  bool found = false;

  Treasure({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  factory Treasure.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Treasure(
      latitude: data['lat number'],
      longitude: data['long number'],
      name: data['hint name'],
    );
  }
}

class TreasureHuntView extends StatefulWidget {
  final String collectionName;
  final List<Treasure> treasures;

  TreasureHuntView({
    required this.collectionName,
    required this.treasures,
  });

  @override
  _TreasureHuntViewState createState() => _TreasureHuntViewState();
}

class _TreasureHuntViewState extends State<TreasureHuntView> {
  int foundTreasures = 0;
  lc.LocationData? userLocation;
  final lc.Location location = lc.Location();
  final hd.HaversineDistance haversineDistance = hd.HaversineDistance();
  Duration timeLeft = Duration(minutes: 1);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> _getLocation() async {
    try {
      final locationData = await location.getLocation();
      setState(() {
        userLocation = locationData;
        timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
      });
    } catch (e) {
      print('Failed to get location: $e');
    }
  }

  void _updateTimer(Timer timer) {
    setState(() {
      print(userLocation);
      timeLeft -= Duration(seconds: 1);
      if (timeLeft.inSeconds <= 0) {
        timer.cancel();
        _showTimeUpDialog();
      }
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Time is up!'),
          content: const Text('You didn\'t find all the treasures in time.'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Reset'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
  setState(() {
    timeLeft = Duration(minutes: 1);
    foundTreasures = 0;
    widget.treasures.forEach((treasure) => treasure.found = false);
  });
  timer?.cancel();
  _getLocation();
}


void _onTreasureTapped(int index) {
  final treasure = widget.treasures[index];
  final distance = haversineDistance.haversine(
    hd.Location(userLocation?.latitude ?? 0, userLocation?.longitude ?? 0),
    hd.Location(treasure.latitude, treasure.longitude),
    hd.Unit.METER,
  );
  if (distance <= 20) {
    setState(() {
      treasure.found = true;
      foundTreasures++;
    });
    if (foundTreasures == widget.treasures.length) {
      // Store user's details in the leaderboard collection
      FirebaseFirestore.instance.collection('leaderboard').add({
        'score': widget.treasures.length,
        'time': DateTime.now(),
        'treasurehunt': widget.collectionName,
      });
      // Show congratulatory dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Congratulations!"),
            content: const Text("You have found all the treasures!"),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text("Reset"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    foundTreasures = 0;
                    widget.treasures.forEach((treasure) {
                      treasure.found = false;
                    });
                  });
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Congratulations!"),
            content: const Text("You have found a treasure! Keep searching."),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  } else {
    final distanceText = '${distance.toStringAsFixed(2)} meters';
    final color = distance > 40 ? Colors.red : distance > 20 ? Colors.yellow : Colors.green;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Too far"),
          content: Text("You are $distanceText away from the treasure", style: TextStyle(color: color)),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
     ); },
    );
  }
}



Widget build(BuildContext context) {

return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.collectionName, style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 10, 10, 10),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(
                'Check out my score in this awesome treasure hunt game!',
                subject: 'Treasure Hunt Game',
              );
            },
          )
        ],
      ),
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [

         const  SizedBox(height: 10,),

           Text('Time left: ${timeLeft.inMinutes}:${timeLeft.inSeconds.remainder(60)}'),
            
          Container(
           

            padding: EdgeInsets.all(16),
            child: Text(
                "Found ${foundTreasures} of ${widget.treasures.length} treasures"),
          ),
        
          Expanded(
            child:GridView.builder(
  itemCount: widget.treasures.length,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      childAspectRatio: 1.0),
  itemBuilder: (BuildContext context, int index) {
    final treasure = widget.treasures[index];
    final distance = haversineDistance.haversine(
      hd.Location(userLocation?.latitude ?? 0, userLocation?.longitude ?? 0),
      hd.Location(treasure.latitude, treasure.longitude),
      hd.Unit.METER,
    );
    final distanceText = '${distance.toStringAsFixed(2)} meters';
    final color = distance > 40 ? Colors.red : distance > 20 ? Colors.yellow : Colors.green;
    
    
    return Container(
  margin: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 1,
        blurRadius: 6,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          treasure.name,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10.0),
        treasure.found
            ? Icon(
                Icons.check,
                color: Colors.green,
              )
            : SizedBox(),
        SizedBox(height: 10.0),
        Text(
          distanceText,
          style: TextStyle(color: color),
        ),
        SizedBox(height: 10.0),
        InkWell(
          onTap: () => _onTreasureTapped(index),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0)),
            child: Center(
              child: Text(
                "Find Treasure",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        SizedBox(height: 10.0),

       SizedBox(height: 10.0),
InkWell(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileView(
          //treasure: widget.treasures[index],
        ),
      ),
    );
  },
  child: Container(
    width: double.infinity,
    decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10.0)),
    child: Center(
      child: Text(
        "Add Location Details",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
  ),
),

      ],
    ),
  ),
);

  },
),

      ),],
      ),
    );
  }
}


