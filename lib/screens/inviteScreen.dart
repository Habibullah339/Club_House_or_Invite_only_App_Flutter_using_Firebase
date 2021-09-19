import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shifahub/models/userModel.dart';

class InviteScreen extends StatefulWidget {
  final UserModel user;
  InviteScreen(this.user);

  @override
  _InviteScreenState createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final TextEditingController inviteController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  @override
  void dispose() {
    inviteController.clear();
    inviteController.dispose();
    super.dispose();
  }

  Future inviteFriend() async {
    if (inviteController.text.trim().length > 8) {
      setState(() {
        isLoading = true;
      });
      _firestore.collection('invitee').add({
        'invitee': inviteController.text,
        'invitedBy': widget.user.phone,
        'date': DateTime.now(),
      }).then((value) {
        int invitesLeft = widget.user.invitesLeft - 1;
        _firestore.collection('users').doc(widget.user.uid).update({
          'invitesLeft': invitesLeft,
        }).then((value) {
          setState(() {
            widget.user.invitesLeft = invitesLeft;
            isLoading = false;
            inviteController.text = "";
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invite your Friends"),
        backgroundColor: Colors.green,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Text(
                "${widget.user.invitesLeft}",
                style: TextStyle(fontSize: 30),
              ),
            ),
            Center(
              child: Text(
                "Invites Left",
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: TextField(
                controller: inviteController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Friend's Phone number With Country Code",
                  hintText: "eg:+923*********",
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            isLoading
                ? CircularProgressIndicator()
                : Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      child: Text(
                        "Invite Now",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      onPressed: () {
                        inviteFriend();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
