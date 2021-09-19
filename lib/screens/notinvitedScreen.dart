import 'package:flutter/material.dart';
import 'package:shifahub/screens/authScreen.dart';

import '../main.dart';

class NotInvitedScreen extends StatelessWidget {
  const NotInvitedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.redAccent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_disabled,
                size: 40,
                color: Colors.white,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "You have not been Invited Yet",
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
              SizedBox(height: 50,),
              TextButton(
                  child: Text(
                      "Go To Login Page".toUpperCase(),
                      style: TextStyle(fontSize: 14)
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white)
                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  },
              ),
              SizedBox(height: 50,),
              Text("Ask Bahiya G To Invite You", style: TextStyle(color: Colors.white, fontSize: 20),),

            ],
          ),
        ),
      ),
    );
  }
}
