// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';


// class LoctionView extends StatefulWidget {
//   @override
//   _LoctionViewState createState() => _LoctionViewState();
// }

// class _LoctionViewState extends State<LoctionView> {
//    String? _address;
//    double? _latitude;
//    double? _longitude;

//   void _getCurrentLocation() async {
//     Placemark placeMark = await Geolocator().placemarkFromAddress(_address);
//     setState(() {
//       _latitude = placeMark[0].position.latitude;
//       _longitude = placeMark[0].position.longitude;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Geolocator Example'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           TextField(
//             onChanged: (value) {
//               _address = value;
//             },
//             decoration: InputDecoration(
//               hintText: 'Enter your address',
//             ),
//           ),
//           SizedBox(height: 20.0),
//           TextButton(
//             onPressed: _getCurrentLocation,
//             child: Text('Get Current Location'),
//           ),
//           SizedBox(height: 20.0),
//           Text('Latitude: $_latitude'),
//           Text('Longitude: $_longitude'),
//         ],
//       ),
//     );
//   }
// }