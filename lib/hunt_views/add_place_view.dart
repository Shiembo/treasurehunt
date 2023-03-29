
import 'package:flutter/material.dart';
import 'package:hunt/hunt_views/map_view.dart' as map_view;
import 'package:hunt/providers/great_places.dart';
import 'package:hunt/widgets/image_input.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../widgets/location_input.dart';
import '../models/place.dart' ;



class AddPlaceView extends StatefulWidget {
  static const routeName = '/addPlace';
  const AddPlaceView({super.key});

  @override
  State<AddPlaceView> createState() => _AddPlaceViewState();
}

class _AddPlaceViewState extends State<AddPlaceView> {
  final _titleController = TextEditingController();
  File? _pickedImage;

  late PlaceLocation _pickedLocation;

  void _selectImage(File pickedImage){
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng){
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng, address: '');
  }

  void _savePlace(){
    if(_titleController.text.isEmpty ||
     _pickedImage == null || 
    _pickedLocation == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen:false).addPlace(_titleController.text, _pickedImage!, _pickedLocation);
    Navigator.of(context).pop();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Add New Locations'),
        backgroundColor: Color.fromARGB(255, 10, 10, 10),
        elevation: 0,
        
    ),
   body: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: <Widget>[
   Expanded(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: _titleController,
            ),

          const  SizedBox(height: 10),

           ImageInput(
  onSelectImage: (File pickedImage) {
    _selectImage(pickedImage);
  },
),

          const  SizedBox(height: 10),

          LocationInput(_selectPlace),



          ],
          ),
      ),
    ),
    ),
    ElevatedButton.icon(
      icon: Icon(Icons.add, size: 24), // Increase the icon size
      label: Text(
        'Add Place',
        style: TextStyle(fontSize: 18), // Increase the font size of the label
      ),
      onPressed: _savePlace,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ), // Increase the button padding to make it bigger
      ),
    ),
  ],
),

    );
  }
}