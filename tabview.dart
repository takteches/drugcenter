import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rwakd_adwyh/test2.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'chat.dart';



class TabView extends StatefulWidget {
  @override
  _TabViewState createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController name= TextEditingController();
  final firebase =FirebaseFirestore.instance ;
  String id=FirebaseAuth.instance.currentUser!.uid;
  String? username=FirebaseAuth.instance.currentUser!.displayName;
  String? url=FirebaseAuth.instance.currentUser!.photoURL;
  TextEditingController contact = TextEditingController();

  var data= FirebaseFirestore.instance.collection("chat");

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();

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
        child: Padding(
          padding: const EdgeInsets.all(8.0),

          child: Column(
            children: [
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(
                    16.0,
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      16.0,
                    ),
                    color: Colors.grey.shade900,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey.shade900,
                  tabs: [
                    Tab(
                      text: 'received',
                    ),
                    Tab(
                      text: 'sent',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Center(
                      child:  SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance.collection("sentrequest").where("reciverid", isEqualTo: id).snapshots(),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  return ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:(context,i) {
                                        var dateString =  DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[i].get('time').millisecondsSinceEpoch) ;
                                        DocumentSnapshot ud =  snapshot.data!.docs[i];

                                        return GestureDetector(
                                          onTap: () {
                                          },
                                          child : Card(
                                            elevation: 3,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
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

                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: 8, right: 2),
                                                              child: Text(snapshot.data!.docs[i].get('drugname'),
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [

                                                                Text("Is It Available ?",
                                                                  style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                                IconButton(
                                                                    onPressed: () {
                                                                      late AwesomeDialog dialog;
                                                                      dialog =AwesomeDialog(
                                                                        context: context,
                                                                        animType: AnimType.scale,
                                                                        dialogType: DialogType.info,
                                                                        keyboardAware: true,
                                                                        body: Padding(
                                                                          padding: const EdgeInsets.all(8.0),
                                                                          child: Column(
                                                                            children: <Widget>[
                                                                              Text(
                                                                                'Contact number',
                                                                                style: Theme.of(context).textTheme.headline6,
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Material(
                                                                                elevation: 0,
                                                                                color: Colors.blueGrey.withAlpha(40),
                                                                                child: TextFormField(

                                                                                  controller: contact,
                                                                                  minLines: 1,
                                                                                  decoration: const InputDecoration(
                                                                                    border: InputBorder.none,
                                                                                    labelText: 'contact number',
                                                                                    prefixIcon: Icon(Icons.text_fields),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              AnimatedButton(
                                                                                isFixedHeight: false,
                                                                                color:Colors.blueGrey,
                                                                                text: 'send',
                                                                                pressEvent: () async{
                                                                                  if(contact.text!=""){
                                                                                    try{
                                                                                      await firebase.collection("sentrequest").doc(ud.id).update({
                                                                                        "contact": contact.text,
                                                                                        "status":"available",
                                                                                      });}
                                                                                    catch(e)
                                                                                    {
                                                                                      print(e);
                                                                                    }
                                                                                    dialog.dismiss();

                                                                                    sendPushMessage("New Request",username! +" reply on your request",snapshot.data!.docs[i]
                                                                                        .get('token'));

                                                                                  }else{
                                                                                    ScaffoldMessenger.of(
                                                                                        context)
                                                                                        .showSnackBar(
                                                                                        SnackBar(
                                                                                          content: Text(
                                                                                              "please  write  contact number"),
                                                                                        ));
                                                                                  }


                                                                                },
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )..show();

                                                                    },
                                                                    icon: Icon(
                                                                        Icons.thumb_up,
                                                                        size: 20)),

                                                                IconButton(
                                                                    onPressed: ()async {
                                                                      AwesomeDialog(
                                                                        context: context,
                                                                        dialogType: DialogType.warning,
                                                                        headerAnimationLoop: false,
                                                                        animType: AnimType.bottomSlide,
                                                                        title: "Not Avaliable",
                                                                        desc: 'Are  you sure ?',
                                                                        buttonsTextStyle: const TextStyle(color: Colors.black),
                                                                        showCloseIcon: true,
                                                                        btnCancelOnPress: () {},
                                                                        btnOkOnPress: () async{
                                                                          try{
                                                                            await firebase.collection("sentrequest").doc(ud.id).update({
                                                                              "reciverid": "",
                                                                              "status": "Not Avaliable",
                                                                              "contact": ""
                                                                            });}
                                                                          catch(e)
                                                                          {
                                                                            print(e);
                                                                          }
                                                                          sendPushMessage("New Request",username! +" reply on your request",snapshot.data!.docs[i]
                                                                              .get('token'));
                                                                        },

                                                                      ).show();


                                                                    },
                                                                    icon: Icon(
                                                                        Icons.clear,
                                                                        size: 20)),

                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text("sent by",style:
                                                                TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                ),),
                                                                SizedBox(width: 10,),
                                                                CircleAvatar(
                                                                  radius: 10.0,
                                                                  backgroundImage:
                                                                  NetworkImage(snapshot.data!.docs[i].get('url')),
                                                                  backgroundColor: Colors.transparent,
                                                                ),
                                                                Text(snapshot.data!.docs[i].get('sendername'),style:
                                                                TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                ),),
                                                                SizedBox(width: 40,),

                                                                Text(dateString.toString(),style:
                                                                TextStyle(
                                                                  fontSize: 10,
                                                                ),),

                                                              ],
                                                            ),


                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),);
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
                    Center(
                      child:  SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance.collection("sentrequest").where("id", isEqualTo: id).snapshots(),
                              builder: (context,snapshot){
                                if(snapshot.hasData){
                                  return ListView.builder(
                                      physics: ScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:(context,i) {
                                        var dateString =  DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[i].get('time').millisecondsSinceEpoch) ;
                                        DocumentSnapshot ud =  snapshot.data!.docs[i];

                                        return GestureDetector(
                                          onTap: () {

                                          },
                                          child : Card(
                                            elevation: 3,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 6),
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Row(
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

                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  left: 8, right: 2),
                                                              child: Text(snapshot.data!.docs[i].get('drugname'),
                                                                style: TextStyle(
                                                                    fontSize: 15,
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Text("posted by",style:
                                                                TextStyle(
                                                                  fontSize: 7,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.black,
                                                                ),),
                                                                SizedBox(width: 10,),
                                                                CircleAvatar(
                                                                  radius: 10.0,
                                                                  backgroundImage:
                                                                  NetworkImage(snapshot.data!.docs[i].get('rurl')),
                                                                  backgroundColor: Colors.transparent,
                                                                ),
                                                                Text(snapshot.data!.docs[i].get('rname'),style:
                                                                TextStyle(
                                                                  fontSize: 9,
                                                                  fontWeight: FontWeight.bold,
                                                                  color: Colors.blue,
                                                                ),),
                                                                SizedBox(width: 40,),

                                                                Text(dateString.toString(),style:
                                                                TextStyle(
                                                                  fontSize: 10,
                                                                ),),

                                                              ],
                                                            ),

                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [

                                                                Text("Status        " + snapshot.data!.docs[i].get('status'),
                                                                  style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                                SizedBox(height: 5,),
                                                                Text("contact info        " + snapshot.data!.docs[i].get('contact'),
                                                                  style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold),
                                                                ),

                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Text("Cancel Request",
                                                                  style: TextStyle(
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold),
                                                                ),

                                                                IconButton(
                                                                    onPressed: (){
                                                                      AwesomeDialog(
                                                                        context: context,
                                                                        dialogType: DialogType.warning,
                                                                        headerAnimationLoop: false,
                                                                        animType: AnimType.bottomSlide,
                                                                        title: "Delete Request ",
                                                                        desc: 'Are  you sure ?',
                                                                        buttonsTextStyle: const TextStyle(color: Colors.black),
                                                                        showCloseIcon: true,
                                                                        btnCancelOnPress: () {},
                                                                        btnOkOnPress: () async{
                                                                          try{
                                                                            await firebase.collection("sentrequest").doc(ud.id).delete();}
                                                                          catch(e)
                                                                          {
                                                                            print(e);
                                                                          }

                                                                        },
                                                                      ).show();


                                                                    },
                                                                    icon: Icon(
                                                                        Icons.clear,
                                                                        size: 20)),
                                                              ],
                                                            ),


                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),);
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

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}