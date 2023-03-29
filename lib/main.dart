import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hunt/firebase_options.dart';
import 'package:hunt/hunt_views/main_view.dart';
import 'package:hunt/views/login_view.dart';
import 'package:provider/provider.dart';
import './providers/great_places.dart';
import './hunt_views/add_place_view.dart';
import './hunt_views/place_details_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GreatPlaces(),
      child:  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainView(),
        routes: {
        AddPlaceView.routeName: (ctx) => AddPlaceView(),
        PlaceDetailView.routeName: (ctx) => PlaceDetailView(),
  },
        
  
        //theme: ThemeData(useMaterial3: true),
      ),
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
