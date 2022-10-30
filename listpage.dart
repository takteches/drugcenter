
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;


class Sera_go extends StatefulWidget {
  @override
  _Sera_goState createState() => _Sera_goState();
}

class _Sera_goState extends State<Sera_go> {
  TextEditingController name = TextEditingController();
  final firebase = FirebaseFirestore.instance;
  TextEditingController controller = TextEditingController();
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  String id = FirebaseAuth.instance.currentUser!.uid;
  String? username = FirebaseAuth.instance.currentUser!.displayName;
  String? url = FirebaseAuth.instance.currentUser!.photoURL;
  String androidSimul = 'Your Android Token';
  late String searchKey;
   var streamQuery ;
  var data = FirebaseFirestore.instance
      .collection("notification")
      .orderBy("time", descending: true);

  String? mtoken = " ";
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
    });
  }






  //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();

    streamQuery=FirebaseFirestore.instance
        .collection("user")
        .orderBy("time", descending: true).snapshots();

  }
  void sendPushMessage(String title,String body,  String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAAhDAtm78:APA91bHKehsC98l2alcH9skvwowzTF-bv6acBUFFD1slgLjGv5Rk52CUWXnau_5QYsqxRqQ0ngPQI1KTiSAKA8nmiAb86kGPpmjJL1gtFXSWidmhLfpNaM32hhltiX8__G00Rc3vypmJ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'badge': 1
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'badge': 1
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: controller,
                  decoration:  InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: 'search by drug name',
                    hintTextDirection: TextDirection.ltr,
                    contentPadding: EdgeInsets.all(15.0),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                      mainAxisSize: MainAxisSize.min, // added line
                      children: [
                        IconButton(
                          onPressed:  controller.clear,
                          icon: const Icon(Icons.clear),
                        ),

                      ],
                    ),
                  ),

                  onChanged: (value){
                    if(value==""){
                      setState(() {
                        streamQuery=FirebaseFirestore.instance
                            .collection("user")
                            .orderBy("time", descending: true).snapshots();
                      });
                    }else{
                      setState(() {
                        searchKey = value;
                        streamQuery = FirebaseFirestore.instance.collection('user')
                            .where('name', isGreaterThanOrEqualTo: searchKey.toLowerCase())
                            .where('name', isLessThan: searchKey.toLowerCase() +'\uf8ff')
                            .snapshots();
                      });
                    }

                  }),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: streamQuery,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          var dateString =
                              DateTime.fromMillisecondsSinceEpoch(snapshot
                                  .data!.docs[i]
                                  .get('time')
                                  .millisecondsSinceEpoch);
                          DocumentSnapshot ud = snapshot.data!.docs[i];
                          int views = snapshot.data!.docs[i].get('views');


                          return GestureDetector(
                            onTap: ()  {

                            },
                            child: Card(
                              elevation: 3,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
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
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [

                                                Container(
                                                    width: 80,
                                                    height: 50,
                                                    child: Image.asset(
                                                        "assets/cap.png")),
                                              ]),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.only(
                                                              left: 8,
                                                              right: 2),
                                                      child: Text(
                                                        snapshot.data!.docs[i]
                                                            .get('name'),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.blue,
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
                                                        "Quantity: " +
                                                            snapshot
                                                                .data!.docs[i]
                                                                .get('quant'),
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
                                                        "Expire: " +
                                                            snapshot
                                                                .data!.docs[i]
                                                                .get(
                                                                    'expire'),
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
                                                        "Price: " +
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
                                                        "City: " +
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
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              if (username !=
                                                                  null&& username != snapshot.data!.docs[i]
                                                                  .get('username')) {
                                                                AwesomeDialog(
                                                                  context: context,
                                                                  dialogType: DialogType.warning,
                                                                  headerAnimationLoop: false,
                                                                  animType: AnimType.bottomSlide,
                                                                  title: 'Request',
                                                                  desc: 'Do  you want  to buy ?',
                                                                  buttonsTextStyle: const TextStyle(color: Colors.black),
                                                                  showCloseIcon: true,
                                                                  btnCancelOnPress: () {},
                                                                  btnOkOnPress: () async{

                                                                      try {
                                                                        await firebase.collection("sentrequest").doc(id+snapshot.data!.docs[i].get('id')).set({
                                                                          'time': DateTime.now(),
                                                                          "id": id,
                                                                          "sendername": username,
                                                                          "url": url,
                                                                          "drugname": snapshot.data!.docs[i]
                                                                              .get('name'),
                                                                          "reciverid": snapshot.data!.docs[i]
                                                                              .get('id'),
                                                                          "rurl": snapshot.data!.docs[i]
                                                                              .get('url'),
                                                                          "rname":snapshot.data!.docs[i]
                                                                              .get('username'),
                                                                          "status": "waiting response",
                                                                          "contact":"waiting response",
                                                                          "token": mtoken,
                                                                        });
                                                                      } catch (e) {
                                                                        print(e);
                                                                      }
                                                                      ScaffoldMessenger.of(
                                                                          context)
                                                                          .showSnackBar(
                                                                          SnackBar(
                                                                            content: Text(
                                                                                "Request sent"),
                                                                          ));
                                                                      setState(() {
                                                                        views += 1;
                                                                      });

                                                                      try {
                                                                        await firebase
                                                                            .collection("user")
                                                                            .doc(ud.id)
                                                                            .update({"views": views});
                                                                      } catch (e) {
                                                                        print(e);
                                                                      }

                                                                      sendPushMessage("New Request",username! +" sent you request",snapshot.data!.docs[i]
                                                                          .get('token'));




                                                                    //notification




                                                                  },
                                                                ).show();




                                                              } else if(username ==
                                                                  null){
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        SnackBar(
                                                                  content: Text(
                                                                      "please login first"),
                                                                ));
                                                              }else{
                                                                print("done");


                                                              }
                                                            },
                                                            icon: Icon(
                                                                Icons.chat,
                                                                size: 20)),
                                                        SizedBox(
                                                          width: 50,
                                                        ),
                                                        Text(snapshot
                                                            .data!.docs[i]
                                                            .get('views')
                                                            .toString()),
                                                        Icon(
                                                            Icons
                                                                .remove_red_eye_outlined,
                                                            size: 20),
                                                        SizedBox(
                                                          width: 50,
                                                        ),
                                                        IconButton(
                                                            onPressed: () async{
                                                              AwesomeDialog(
                                                                context: context,
                                                                dialogType: DialogType.warning,
                                                                headerAnimationLoop: false,
                                                                animType: AnimType.bottomSlide,
                                                                title: "Report ",
                                                                desc: 'Are  you sure ?',
                                                                buttonsTextStyle: const TextStyle(color: Colors.black),
                                                                showCloseIcon: true,
                                                                btnCancelOnPress: () {},
                                                                btnOkOnPress: () async{
                                                                  try {
                                                                    await firebase.collection("report").doc().set({
                                                                      "postid": ud

                                                                    });
                                                                  } catch (e) {
                                                                    print(e);
                                                                  }
                                                                  ScaffoldMessenger.of(
                                                                      context)
                                                                      .showSnackBar(
                                                                      SnackBar(
                                                                        content: Text(
                                                                            "report sent"),
                                                                      ));

                                                                },
                                                              ).show();




                                                            },
                                                            icon: Icon(
                                                                Icons.report,
                                                                size: 20)),
                                                      ],
                                                    )
                                                  ],
                                                ),
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
                            ),
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
