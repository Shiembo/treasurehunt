import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hunt/models/place.dart';



class MapView extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapView({
    Key? key,
    this.initialLocation = const PlaceLocation(latitude: 52.58918052717125, longitude: -2.1207260409161495, address: ''),
    this.isSelecting = false,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}


class _MapViewState extends State<MapView> {
  LatLng? _pickedLocation;

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Map'),
        actions: <Widget>[
        if (widget.isSelecting)
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _pickedLocation == null ? null : (){
              Navigator.of(context).pop(_pickedLocation);
            },),
      ],
        backgroundColor: Color.fromARGB(255, 15, 14, 15),
        elevation: 0,
      ),
      backgroundColor: Colors.green[700],
      body: GoogleMap(
       initialCameraPosition: CameraPosition(
  target: LatLng(
    widget.initialLocation.latitude ?? 0.0,
    widget.initialLocation.longitude ?? 0.0,
  ),
  zoom: 16,
),

        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? {}
            : {
                Marker(
                  markerId: MarkerId('m1'),
                  position: _pickedLocation ?? 
                  LatLng(
                    widget.initialLocation.latitude ?? 0.0,
                    widget.initialLocation.longitude ?? 0.0,
                  ),
                ),
              },
      ),
    );
  }
}
