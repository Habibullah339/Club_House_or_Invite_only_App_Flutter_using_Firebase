import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shifahub/main.dart';
import 'package:shifahub/models/userModel.dart';
import 'package:shifahub/screens/createAClub.dart';
import 'package:shifahub/screens/inviteScreen.dart';
import 'package:shifahub/screens/profileScreen.dart';
import 'package:shifahub/widgets/ongoingClub.dart';
import 'package:shifahub/widgets/upcomingClub.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  HomeScreen({required this.user});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    if(widget.user.name==""){
     Future.microtask(() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProfileScreen(widget.user))));
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1efe5),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateAClub(widget.user)));
        },
      ),
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text("Invite"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InviteScreen(widget.user)));
            },
          )
        ],
      )),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,

        title: Text("Home", style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new_outlined),
            onPressed: () async {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthenticateUser()));
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
OngoingClub(),
            SizedBox(height: 10,),
            Text("Upcoming Week Events", style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10,),
            Icon(Icons.arrow_circle_down),
UpComingClub(),
          ],
        ),
      ),
    );
  }
}
