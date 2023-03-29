

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../helpers/location_helper.dart';
import '../hunt_views/map_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  const LocationInput(this.onSelectPlace);

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageURL;

  void _showPreview(double lat, double lng){
    final  staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
    latitude: lat, 
    longitude:  lng,
    );

    setState((){
      _previewImageURL = staticMapImageUrl;

    });

  }

  Future<void> _getCurrentUserLocation() async {
  final locData = await Location().getLocation();
  if (locData.latitude != null && locData.longitude != null) {
    _showPreview(locData.latitude!, locData.longitude!);
    widget.onSelectPlace(locData.latitude!, locData.longitude!);
  }
}

 Future<void> _selectOnMap() async {
  try {
    final locData = await Location().getLocation();
    if (locData.latitude != null && locData.longitude != null) {
      _showPreview(locData.latitude!, locData.longitude!);
      widget.onSelectPlace(locData.latitude!, locData.longitude!);
    }
  } catch (error) {
    return;
  }




    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapView(
          isSelecting: true,
        ) ,)
    );
    if(selectedLocation == null){
      return;
    }
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey),),
          child: _previewImageURL == null
              ? Text(
                  'No Location Chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageURL!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  
  children: <Widget>[
    ElevatedButton.icon(
      icon: Icon(Icons.location_on),
      label: Text('Current Location'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: _getCurrentUserLocation,
    ),
    ElevatedButton.icon(
      icon: Icon(Icons.map),
      label: Text('Select on Map'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      onPressed: _selectOnMap,
    ),
  ],
),

      ],
    );
  }
}
