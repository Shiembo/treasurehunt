// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class VerificationEmailPage extends StatefulWidget {
//   @override
//   _VerificationEmailPageState createState() => _VerificationEmailPageState();
// }

// class _VerificationEmailPageState extends State<VerificationEmailPage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   String _email;
//   String _verificationId;

//   @override
//   void initState() {
//     super.initState();
//     _auth.currentUser().then((user) {
//       setState(() {
//         _email = user.email;
//       });
//     });
//     _auth.onAuthStateChanged.listen((user) {
//       if (user.isEmailVerified) {
//         Navigator.of(context).popUntil((route) => route.isFirst);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Verification Email'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('A verification email has been sent to $_email.'),
//             SizedBox(height: 16.0),
//             RaisedButton(
//               child: Text('Resend Email'),
//               onPressed: () async {
//                 _verificationId = await _auth.currentUser().then((user) {
//                   return user.sendEmailVerification();
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }