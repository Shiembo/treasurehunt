
import 'package:flutter/material.dart';
import 'package:hunt/hunt_views/treasure_view.dart';
import 'package:haversine_distance/haversine_distance.dart' as hd;
import 'package:location/location.dart' as lc;

class TreasureDistanceView extends StatefulWidget {
  final Treasure treasure;
  final lc.LocationData userLocation;

  TreasureDistanceView({required this.treasure, required this.userLocation});

  @override
  _TreasureDistanceViewState createState() => _TreasureDistanceViewState();
}

class _TreasureDistanceViewState extends State<TreasureDistanceView> {
  final hd.HaversineDistance haversineDistance = hd.HaversineDistance();

  @override
  Widget build(BuildContext context) {
   double? userLatitude = widget.userLocation.latitude;
double? userLongitude = widget.userLocation.longitude;
double distance = 0.0;
if (userLatitude != null && userLongitude != null) {
  distance = haversineDistance.haversine(
    hd.Location(userLatitude, userLongitude),
    hd.Location(widget.treasure.latitude, widget.treasure.longitude),
    hd.Unit.METER,
  );
}
Color distanceColor;
String distanceText;
if (distance <= 20) {
  distanceText = "You found the treasure!";
  distanceColor = Colors.green;
} else if (distance <= 50) {
  distanceText = "You're getting close! Distance: ${distance.toStringAsFixed(1)}m";
  distanceColor = Colors.yellow;
} else {
  distanceText = "Distance: ${distance.toStringAsFixed(1)}m";
  distanceColor = Colors.red;
}


    return Text(
      distanceText,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: distanceColor),
    );
  }
}