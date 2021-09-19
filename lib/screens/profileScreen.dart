import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shifahub/models/userModel.dart';
import 'package:shifahub/screens/homeScreen.dart';
class ProfileScreen extends StatelessWidget {
  final UserModel user;
  ProfileScreen(this.user);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text:user.name);
    return Scaffold(
      backgroundColor: Color(0xfff1efe5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),

      ),
      body: Padding(padding: EdgeInsets.all(30),
child: Column(
  children: [
    CircleAvatar(
      radius: 50,
      child: Icon(Icons.person, size: 50,),
    ),
    SizedBox(height: 20,),
    TextField(
      controller:nameController ,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Enter Your Full Name...",
      ),
    ),
    SizedBox(height: 20,),
    ElevatedButton(onPressed: (){
      if(nameController.text!= ""){
        FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': nameController.text,
        }).then((value){
          user.name= nameController.text;
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen(user: user)));
        });
      }
    }, child: Text("Update"))
  ],
),

      ),
    );
  }
}
