import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class UpComingClub extends StatelessWidget {
  const UpComingClub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(

      shrinkWrap: true,
      itemCount: 8,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Learn Flutter And Firebase || UET Taxila",
                    style: TextStyle(fontSize: 18),),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.account_tree_sharp, color: Colors.green,),
                      SizedBox(width: 5,),
                      Text("IT"),
                      SizedBox(width: 20,),
                      Icon(Icons.date_range_outlined),
                      SizedBox(width: 5,),
                      Text("9th Sept 5:00 PM"),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person, color: Colors.blue,),
                      SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Habibullah From UET"),
                          Text("Bahiya G "),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      },


    );
  }}