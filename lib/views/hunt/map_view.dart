import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as lc;
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

class MapView extends StatefulWidget {
  MapView({Key? key}) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  lc.LocationData? userLocation;
  lc.Location location = lc.Location();
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  void _checkPermission() async {
    var permission = await location.hasPermission();
    if (permission == lc.PermissionStatus.granted) {
      _getUserLocation();
    } else {
      var permissionRequest = await location.requestPermission();
      if (permissionRequest == lc.PermissionStatus.granted) {
        _getUserLocation();
      } else {
        // Handle the case where the permission was denied
        _showPermissionDeniedDialog();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Permission denied"),
            content: Text("Please grant permission in settings"),
            actions: <Widget>[
              ElevatedButton(
                child: Text("Settings"),
                onPressed: () {
                  AppSettings.openAppSettings();
                },
              ),
            ],
          );
        });
  }

  void _getUserLocation() {
    location.getLocation().then((locationData) {
      setState(() {
        userLocation = locationData;
        _markers.add(
          Marker(
            markerId: MarkerId('user_location'),
            position: LatLng(
              userLocation?.latitude ?? 0,
              userLocation?.longitude ?? 0,
            ),
            infoWindow: InfoWindow(
              title: 'Your Location',
            ),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });
    }).catchError((e) {
      // Handle the error here
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: _markers,
        initialCameraPosition: CameraPosition(
            target: LatLng(
                userLocation?.latitude ?? 0, userLocation?.longitude ?? 0),
            zoom: 15),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getUserLocation,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
