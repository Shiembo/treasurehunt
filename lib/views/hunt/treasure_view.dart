import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haversine_distance/haversine_distance.dart' as hd;
import 'package:location/location.dart' as lc;
import 'package:share_plus/share_plus.dart';

class Treasure {
  double latitude;
  double longitude;
  String name;
  bool found = false;

  Treasure(
      {required this.latitude, required this.longitude, required this.name});

  factory Treasure.fromSnapshot(DocumentSnapshot snapshot) {
    return Treasure(
      latitude: (snapshot.data() as Map<String, dynamic>)['lat number'],
      longitude: (snapshot.data() as Map<String, dynamic>)['long number'],
      name: (snapshot.data() as Map<String, dynamic>)['hint name'],
    );
  }
}

class TreasureHuntView extends StatefulWidget {
  final String collectionName;
  final List<Treasure> treasures;

  TreasureHuntView({required this.collectionName, required this.treasures});

  @override
  _TreasureHuntViewState createState() => _TreasureHuntViewState();
}

class _TreasureHuntViewState extends State<TreasureHuntView> {
  int foundTreasures = 0;
  lc.LocationData? userLocation;
  final lc.Location location = lc.Location();
  final hd.HaversineDistance haversineDistance = hd.HaversineDistance();
  late DateTime _startTime;
  final _duration = const Duration(minutes: 5);
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    location.getLocation().then((locationData) {
      print(locationData);

      setState(() {
        userLocation = locationData;
      });
    }).catchError((e) {
      // Handle the error here
      print(e);
    });

    @override
    void dispose() {
      _timer.cancel();
      super.dispose();
    }

    _startTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final remainingTime = _duration - (DateTime.now().difference(_startTime));
      if (remainingTime.isNegative) {
        _timer.cancel();
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Time's up!"),
                content: const Text("The time for the treasure hunt is over."),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      } else {
        // Update the remaining time in minutes and seconds
        if (mounted) {
          setState(() {
            _minutes = remainingTime.inMinutes;
            _seconds = remainingTime.inSeconds - _minutes * 60;
          });
        }
      }
    });
  }

  void _onTreasureTapped(int index) {
    final remainingTime = _duration - (DateTime.now().difference(_startTime));
    if (remainingTime.inSeconds <= 0) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Time's up!"),
              content: const Text("The time for the treasure hunt is over "),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      return;
    }
    double distance = haversineDistance.haversine(
        hd.Location(userLocation?.latitude ?? 0, userLocation?.longitude ?? 0),
        hd.Location(widget.treasures[index].latitude,
            widget.treasures[index].longitude),
        hd.Unit.METER);
    if (distance <= 20) {
      setState(() {
        widget.treasures[index].found = true;
        foundTreasures++;
      });
      if (foundTreasures == widget.treasures.length) {
        _timer.cancel();
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Too far"),
            content: const Text("You are too far from the treasure"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  late int _minutes;
  late int _seconds;
  @override
  Widget build(BuildContext context) {
    final remainingTime = _duration - (DateTime.now().difference(_startTime));
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.collectionName, style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 255, 0, 255),
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
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
                "Found ${foundTreasures} of ${widget.treasures.length} treasures"),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
                "Time remaining: ${remainingTime.inMinutes}:${remainingTime.inSeconds.toString().padLeft(2, '0')}"),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: widget.treasures.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1.0),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 10.0),
                      Text(
                        widget.treasures[index].name,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10.0),
                      widget.treasures[index].found
                          ? Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : SizedBox(),
                      SizedBox(height: 10.0),
                      InkWell(
                        onTap: () => _onTreasureTapped(index),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: const Center(
                            child: Text(
                              "Find Treasure",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
