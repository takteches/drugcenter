import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'adhelper.dart';

class my_post extends StatefulWidget {
  @override
  _my_postState createState() => _my_postState();
}

class _my_postState extends State<my_post> {
  TextEditingController name= TextEditingController();
  final firebase =FirebaseFirestore.instance ;
  String id=FirebaseAuth.instance.currentUser!.uid;
  String? username=FirebaseAuth.instance.currentUser!.displayName;


  //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;

  Create()async{
    try{
      await firebase.collection("user").doc().set(
          {
            "id" : id,
            "name": name.text
          }
      );

    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Container(
          color: Colors.grey.shade300,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("user").where("id", isEqualTo: id).snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder:(context,i) {
                            var dateString =  DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[i].get('time').millisecondsSinceEpoch) ;
                           DocumentSnapshot ud =  snapshot.data!.docs[i];

                            return  Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [

                                            Row(
                                              children: [
                                                Column(

                                                    children:[
                                                      Container(
                                                          width:80,
                                                          height: 50,
                                                          child: Image.asset("assets/cap.png")),]),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8, right: 2),
                                                      child: Text(snapshot.data!.docs[i].get('name'),
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.blue,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8, right: 2),
                                                      child: Text("Quantity: "+ snapshot.data!.docs[i].get('quant'),
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8, right: 2),
                                                      child: Text("Expire: "+snapshot.data!.docs[i].get('expire'),
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: 8,
                                                          right: 2),
                                                      child: Text(
                                                        "price: " +
                                                            snapshot
                                                                .data!.docs[i]
                                                                .get(
                                                                'price'),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          left: 8,
                                                          right: 2),
                                                      child: Text(
                                                        "country: " +
                                                            snapshot
                                                                .data!.docs[i]
                                                                .get(
                                                                'country'),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [

                                                        IconButton(onPressed: () async {

                                                          AwesomeDialog(
                                                            context: context,
                                                            dialogType: DialogType.warning,
                                                            headerAnimationLoop: false,
                                                            animType: AnimType.bottomSlide,
                                                            title: "Delete",
                                                            desc: 'Are  you sure ?',
                                                            buttonsTextStyle: const TextStyle(color: Colors.black),
                                                            showCloseIcon: true,
                                                            btnCancelOnPress: () {},
                                                            btnOkOnPress: () async{
                                                              try{
                                                                await firebase.collection("user").doc(ud.id).delete();}
                                                              catch(e)
                                                              {
                                                                print(e);
                                                              }

                                                            },
                                                          ).show();


                                                        }, icon: Icon(Icons.delete, size:20)),
                                                        SizedBox(width: 50,),
                                                        Text(snapshot.data!.docs[i].get('views').toString()),
                                                        Icon(Icons.remove_red_eye_outlined, size:20),
                                                        SizedBox(width: 50,),



                                                      ],



                                                    )


                                                  ],),
                                                )


                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Posted By",
                                                  style: TextStyle(
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),

                                                CircleAvatar(
                                                  radius: 10.0,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data!.docs[i]
                                                          .get('url')),
                                                  backgroundColor:
                                                  Colors.transparent,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  snapshot.data!.docs[i]
                                                      .get('username'),
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 40,
                                                ),
                                                Text(
                                                  dateString.toString(),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),






                                          ],
                                        ),
                                      )),
                                ],
                              ),

                              ),
                            );
                          }
                      );
                    }else{
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),


              ],
            ),
          ),

        ),
      ),
    );
  }
}