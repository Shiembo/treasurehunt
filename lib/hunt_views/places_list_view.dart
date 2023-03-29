import 'package:flutter/material.dart';
import 'package:hunt/hunt_views/add_place_view.dart';
import 'package:hunt/providers/great_places.dart';
import 'package:provider/provider.dart';
import './place_details_view.dart';

class PlacesListView extends StatelessWidget {
  const PlacesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Locations'),
        backgroundColor: Color.fromARGB(255, 10, 10, 10),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceView.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
        .fetchAndSetPlaces(),
        builder:(ctx, snapshot) => snapshot.connectionState == 
        ConnectionState.waiting ? const  Center(
          child: CircularProgressIndicator(),
          )
          : Consumer<GreatPlaces>(
          child:const  Center(
            child:   Text('Got no locations yet, start adding some!'),
          ),
          builder: (ctx, greatPlaces, ch) => greatPlaces.items.isEmpty
              ? ch as Widget
              : ListView.builder(
        itemCount: greatPlaces.items.length,
        itemBuilder: (ctx, i) {
          return ListTile(
        leading: CircleAvatar(
          backgroundImage: FileImage(
            greatPlaces.items[i].image,
          ),
        ),
        title: Text(greatPlaces.items[i].title),
        subtitle: Text(greatPlaces.items[i].location.address),
        onTap: () {
          Navigator.of(context).pushNamed(
            PlaceDetailView.routeName,
            arguments: greatPlaces.items[i].id,
          );

        },
          );
        },
      ),
      
        ),
      ),
    );
  }
}
