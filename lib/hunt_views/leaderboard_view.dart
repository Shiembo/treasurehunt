import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaderboardView extends StatefulWidget {
  @override
  _LeaderboardViewState createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {
  List<QueryDocumentSnapshot> leaderboardData = [];

  @override
  void initState() {
    super.initState();
    _loadLeaderboardData();
  }

  Future<void> _loadLeaderboardData() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .orderBy('time')
        .limit(10)
        .get();
    setState(() {
      leaderboardData = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 10, 10, 10),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: leaderboardData.length,
        itemBuilder: (context, index) {
          final data = leaderboardData[index].data();
         final score = (data as Map<String, dynamic>)['score'];
         final time = ((data as Map<String, dynamic>)['time'] as Timestamp).toDate();
         final treasureHunt = (data as Map<String, dynamic>)['treasurehunt'];

          return ListTile(
            leading: Text((index + 1).toString()),
            title: Text('Score: $score'),
            subtitle: Text('Time: ${DateFormat.yMd().add_jm().format(time)}'),
            trailing: Text(treasureHunt),
          );
        },
      ),
    );
  }
}
