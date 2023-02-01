import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:thehunt/views/hunt/hunt_view.dart';

import 'package:thehunt/views/hunt/treasure_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference completedTreasureHuntCollection =
      FirebaseFirestore.instance.collection(
    'completed_treasure_hunts',
  );
  List<Treasure> treasureHuntOneLocations = [];
  List<Treasure> treasureHuntTwoLocations = [];
  List<Treasure> treasureHuntThreeLocations = [];
  List<Map<String, dynamic>> completedTreasureHunts = [];

  @override
  void initState() {
    super.initState();

    // Retrieve locations for treasurehunt one
    final CollectionReference treasureHuntOneCollection = FirebaseFirestore
        .instance
        .collection('treasurehunt')
        .doc('treasurehuntone')
        .collection("locations");
    treasureHuntOneCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Treasure treasure = Treasure.fromSnapshot(doc);
        treasureHuntOneLocations.add(treasure);
      });
    }).catchError((e) {
      // Handle the error here
      print(e);
    });

    // Retrieve locations for treasurehunt two
    final CollectionReference treasureHuntTwoCollection = FirebaseFirestore
        .instance
        .collection('treasurehunt')
        .doc('treasurehunttwo')
        .collection("locations");
    treasureHuntTwoCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Treasure treasure = Treasure.fromSnapshot(doc);
        treasureHuntTwoLocations.add(treasure);
      });
    }).catchError((e) {
      // Handle the error here
      print(e);
    });

    // Retrieve locations for treasurehunt three
    final CollectionReference treasureHuntThreeCollection = FirebaseFirestore
        .instance
        .collection('treasurehunt')
        .doc('treasurehuntthree')
        .collection("locations");
    treasureHuntThreeCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Treasure treasure = Treasure.fromSnapshot(doc);
        treasureHuntThreeLocations.add(treasure);
      });
    }).catchError((e) {
      // Handle the error here
      print(e);
    });

    // Retrieve completed treasure hunts of the user
    completedTreasureHuntCollection
        .where('email', isEqualTo: user.email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        completedTreasureHunts.add(doc.data() as Map<String, dynamic>);
      });
    }).catchError((e) {
      print("Error retrieving completed treasure hunts: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Treasure Hunt"),
        backgroundColor: Color.fromARGB(255, 255, 0, 255),
        elevation: 0,
      ),
      drawer: const NavigationDrawer(),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 0, 255),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Text(
              "Welcome " + user.email!,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.white),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey[300]!.withOpacity(1),
                              width: 1.0))),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                    title: Text(
                      "Treasure Hunt One",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TreasureHuntView(
                                collectionName: "TreasureHunt One",
                                treasures: treasureHuntOneLocations)),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey[300]!.withOpacity(1),
                              width: 1.0))),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                    title: Text(
                      "Treasure Hunt Two",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TreasureHuntView(
                                collectionName: "TreasureHunt Two",
                                treasures: treasureHuntTwoLocations)),
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey[300]!.withOpacity(1),
                              width: 1.0))),
                  child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      color: Colors.green,
                    ),
                    title: Text(
                      "Treasure Hunt Three",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TreasureHuntView(
                                collectionName: "TreasureHunt Three",
                                treasures: treasureHuntThreeLocations)),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
