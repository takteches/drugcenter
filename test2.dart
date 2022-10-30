import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rwakd_adwyh/ui.dart';

import 'tabview.dart';

class chato extends StatefulWidget {
  const chato({
    Key? key,
    required this.recieverid,
    required this.senderid,
    required this.senderurl,
    required this.sendername,

  }) : super(key: key);

  final String recieverid;
  final String senderid;
  final String senderurl;
  final String sendername;




  @override
  _chatoState createState() => _chatoState();
}

class _chatoState extends State<chato> {
  final firebase =FirebaseFirestore.instance ;
  TextEditingController chat_log= TextEditingController();
  String? userid=FirebaseAuth.instance.currentUser!.uid;
  String? username=FirebaseAuth.instance.currentUser!.displayName;
  String? url=FirebaseAuth.instance.currentUser!.photoURL;
  bool value =true ;

  Create()async{
    try{
      String mix= widget.senderid.toString() + widget.recieverid.toString();
      await firebase.collection("chat").doc(mix).collection("room").doc().set(
          {
            "sender": userid,
            "sendername" :username,
            "url": url,
            "receiver":widget.recieverid,
            "msg":chat_log.text,
            'time':DateTime.now(),
          }
      );

    }catch(e){
      print(e);
    }
  }
  Create2()async{
    try{
      String mix= widget.senderid.toString() + widget.recieverid.toString();
      await firebase.collection("chat").doc(mix).set(
          {
            "sender": widget.senderid,
            "sendername" :username,
            "recievename" :widget.sendername,
            "rurl": widget.senderurl,
            "surl": url,
            "receiver":widget.recieverid,
            "msg":chat_log.text,
            'time':DateTime.now(),
          }
      );

    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blueGrey,
              flexibleSpace: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    children: <Widget>[
                      SizedBox(width: 20,),
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.senderurl),
                        maxRadius: 20,
                      ),
                      SizedBox(width: 12,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(widget.sendername,style: TextStyle( color:Colors.white,fontSize: 16 ,fontWeight: FontWeight.w600),),
                            SizedBox(height: 6,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("chat").doc(widget.senderid.toString() + widget.recieverid.toString()).collection("room").orderBy("time",descending: false).snapshots(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          physics: ScrollPhysics(),
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder:(context,i) {
                            var dateString =  DateTime.fromMillisecondsSinceEpoch(snapshot.data!.docs[i].get('time').millisecondsSinceEpoch) ;
                            if(snapshot.data!.docs[i].get('sender')== userid){
                              value=true;
                            }else{
                              value=false;
                            }

                            return  ChatBubble(
                              text: snapshot.data!.docs[i].get('msg'),

                              isCurrentUser : value ,


                            );
                          }
                      );
                    }else{
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                SizedBox(height: 5,),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(Icons.add, color: Colors.white, size: 20, ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: TextField(
                            controller: chat_log,
                            decoration: InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        FloatingActionButton(
                          onPressed: (){
                            if(chat_log.text.trim()!="" ){
                              Create();
                              Create2();
                              chat_log.clear();
                            }else{
                              print("done");
                            }


                          },
                          child: Icon(Icons.send,color: Colors.white,size: 18,),
                          backgroundColor: Colors.blueGrey,
                          elevation: 0,
                        ),
                      ],

                    ),
                  ),
                ),
              ],
            ),
        );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? Colors.blueGrey : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isCurrentUser ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
