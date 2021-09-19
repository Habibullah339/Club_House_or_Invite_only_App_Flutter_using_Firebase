import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shifahub/screens/authScreen.dart';
import 'package:shifahub/screens/homeScreen.dart';
import 'package:shifahub/models/userModel.dart';
import 'package:shifahub/screens/notinvitedScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shifa Hub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticateUser(),
    );
  }
}

class AuthenticateUser extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future CheckCurrentUser() async {
    if (_firebaseAuth.currentUser != null) {
      var userInvited = await FirebaseFirestore.instance
          .collection("invites")
          .where("invitee", isEqualTo: _firebaseAuth.currentUser!.phoneNumber)
          .get();
      if (userInvited.docs.length < 1) {
        return NotInvitedScreen();
      }

      var userExist = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: _firebaseAuth.currentUser!.uid)
          .get();
      UserModel user = UserModel.fromMap(userExist.docs.first);
      return HomeScreen(user: user);
    } else {
      return AuthScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CheckCurrentUser(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.blue,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          );
        } else {
          return snapshot.data;
        }
      },
    );
  }
}
