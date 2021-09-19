import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String uid;
  String phone;
  int invitesLeft;

  UserModel(
      {required this.name,
      required this.invitesLeft,
      required this.phone,
      required this.uid});

  factory UserModel.fromMap(QueryDocumentSnapshot documentSnapshot) {
    return UserModel(
      name: documentSnapshot['name'],
      phone: documentSnapshot['phone'],
      invitesLeft: documentSnapshot['invitesLeft'],
      uid: documentSnapshot['uid'],
    );
  }

  Map<String, dynamic> toMap(UserModel user) => {
        'name': user.name,
        'uid': user.uid,
        'phone': user.phone,
        'invitesLeft': user.invitesLeft,
      };
}
