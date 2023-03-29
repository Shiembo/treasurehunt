

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';
import './map_view.dart';

class PlaceDetailView extends StatelessWidget {
  static const routeName = '/place-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String; 
    final selectedPlace = Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
        backgroundColor: Color.fromARGB(255, 11, 11, 11),
        elevation: 0,
      ),
      body: Column(children: <Widget>[
        Container(
          height: 250,
          width: double.infinity,
          child: Image.file(
            selectedPlace.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          selectedPlace.location.address,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          child: Text('View on Map'),
          style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (ctx) => MapView(
                  initialLocation: selectedPlace.location,
                  isSelecting: false,
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
