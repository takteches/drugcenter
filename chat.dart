import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class chat extends StatefulWidget {

  const chat({
    Key? key,
    required this.recieverid,
    required this.senderid,

  }) : super(key: key);

 final String recieverid;
  final String senderid;


  @override
  _chatState createState() => _chatState();
}
final firebase =FirebaseFirestore.instance ;
TextEditingController chat_log= TextEditingController();
String? userid=FirebaseAuth.instance.currentUser!.uid;
String? username=FirebaseAuth.instance.currentUser!.displayName;
String? url=FirebaseAuth.instance.currentUser!.photoURL;

   bool value =true ;


class _chatState extends State<chat> {

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

 @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade300,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 600,
                width: double.infinity,
                child: Expanded(
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance.collection("chat").doc(widget.senderid.toString() + widget.recieverid.toString()).collection("room").orderBy("time",descending: false).snapshots(),
                      builder: (context,snapshot){
                        if(snapshot.hasData){
                          return ListView.builder(
                              physics: ScrollPhysics(),
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
                  ),
                ),

              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: chat_log,
                  decoration: InputDecoration(
                    border: InputBorder.none,

                    suffixIcon: IconButton(
                      onPressed: (){
                        if(chat_log.text.trim()!="" ){
                          Create();
                          chat_log.clear();
                        }else{
                          print("done");
                        }

                      },
                      icon: Icon(Icons.send),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 6.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),

              ),


            ],
          ),
        ),

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
            color: isCurrentUser ? Colors.blue : Colors.grey[300],
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
