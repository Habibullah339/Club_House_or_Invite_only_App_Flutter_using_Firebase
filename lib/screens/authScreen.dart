import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shifahub/models/userModel.dart';
import 'package:shifahub/screens/homeScreen.dart';
import 'package:shifahub/screens/notinvitedScreen.dart';
import 'package:shifahub/screens/notinvitedScreen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  bool isotpScreen = false;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var verificationCode;
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future phoneAuth() async {
    var _phoneNumber = phoneController.text.trim();
    setState(() {
      isLoading = true;
    });
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: _phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          _firebaseAuth.signInWithCredential(credential).then((userdata) async {
            if (userdata != null) {
              await _firestore.collection("Users").doc(userdata.user!.uid).set({
                'name': '',
                'phone': userdata.user!.phoneNumber,
                'uid': userdata.user!.uid,
                'invitesLeft': 5,
              });

              setState(() {
                isLoading = false;
              });
              //Navigate to  Home Screen in Future
            }
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          print("Firebase Error : ${error.message}");
        },
        codeSent: (String verificationid, int) {
          setState(() {
            isLoading = false;
            isotpScreen = true;
            verificationCode = verificationid;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isLoading = false;
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 120));
  }

  Future otpSignIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      _firebaseAuth
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: verificationCode,
              smsCode: otpController.text.trim()))
          .then((userdata) async {
        UserModel user;
        if (userdata != null) {
          var userExist = await _firestore
              .collection('users')
              .where('phone', isEqualTo: phoneController.text)
              .get();
          if (userExist.docs.length > 0) {
            print("User Already Exist");
            user = UserModel.fromMap(userExist.docs.first);
          } else {
            print("New User Created");
            user = UserModel(
              name: '',
              invitesLeft: 5,
              phone: userdata.user!.phoneNumber.toString(),
              uid: userdata.user!.uid,
            );
            await _firestore.collection("users").doc(userdata.user!.uid).set(
                UserModel(phone: '', uid: '', invitesLeft: 5, name: '')
                    .toMap(user));
          }

          var userInvited = await _firestore
              .collection("invites")
              .where("invitee", isEqualTo: phoneController.text)
              .get();
          if (userInvited.docs.length < 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => NotInvitedScreen()));
            return;
          }

          setState(() {
            isLoading = false;
          });
          print("LogIn Successful");

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        user: user,
                      )));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.blue,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.only(top: 60),
                  height: 150,
                  child: Text(
                    "SHIFA HUB",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Icon(
                        Icons.connect_without_contact,
                        size: 60,
                        color: Colors.green,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Login With Phone",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 20),
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText:
                                    "Enter Phone Number With Country Code",
                                hintText: "Enter Your Invited Phone Number"),
                          )),
                      isotpScreen
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: TextField(
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter The OTP",
                                    hintText: "Enter the OTP You Got"),
                              ))
                          : SizedBox(
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
                              child: ElevatedButton(
                                onPressed: () {
                                  isotpScreen ? otpSignIn() : phoneAuth();
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
