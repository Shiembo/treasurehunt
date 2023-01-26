import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetHintName extends StatelessWidget {
  final String documentId;

  GetHintName({required this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference treasurehuntone =
        FirebaseFirestore.instance.collection('treasurehuntone');
    return FutureBuilder<DocumentSnapshot>(
      future: treasurehuntone.doc(documentId).get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text('${data['hint name']}' +
              '   ' '${data['lat number']}' +
              '   ' '${data['long number']}');
        }
        return Text('loading...');
      }),
    );
  }
}
