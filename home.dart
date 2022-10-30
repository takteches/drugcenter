
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rwakd_adwyh/wrapper.dart';
import 'package:getwidget/getwidget.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'adhelper.dart';
import 'dialog.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  String? url=FirebaseAuth.instance.currentUser!.photoURL;
  String? name=FirebaseAuth.instance.currentUser!.displayName;
  String test ="";

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;




  //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;


  @override


  void initState() {

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
    super.initState();


      if(url==null && name == null){
        url="https://www.kindpng.com/picc/m/78-785827_user-profile-avatar-login-account-male-user-icon.png";
        name="Guest";
        test="Log In";
      }else {
        url=FirebaseAuth.instance.currentUser!.photoURL;
        name=FirebaseAuth.instance.currentUser!.displayName;
        test= "Log Out";
      };

  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height:30,),
              Column(
                children: [

                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                    NetworkImage(url!),
                    backgroundColor: Colors.transparent,
                  ),


                  Text(
                    name!,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),

                ],
              ),

              const SizedBox(
                height: 70,
              ),


              GFButton(
                onPressed: (){

                },
                text: "Contact Us",
                color: Colors.blueGrey,
                shape: GFButtonShape.pills,
                fullWidthButton: true,
              ),
              GFButton(
                onPressed: (){


                },
                text: "Help",
                color: Colors.blueGrey,
                shape: GFButtonShape.pills,
                fullWidthButton: true,
              ),
              GFButton(
                onPressed: (){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    title: test,
                    desc: 'Are  you sure ?',
                    buttonsTextStyle: const TextStyle(color: Colors.black),
                    showCloseIcon: true,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async{
                      if(test=="Log Out"){
                        AuthService().signOut();
                        setState(() {
                          test="Log In";
                        });

                      }else{
                        AuthService().delete();
                      }
                    },
                  ).show();

                },
                color: Colors.blueGrey,
                text: test,
                shape: GFButtonShape.pills,
                fullWidthButton: true,
              ),
              GFButton(
                onPressed: (){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    headerAnimationLoop: false,
                    animType: AnimType.bottomSlide,
                    title: 'Delete  Account',
                    desc: 'Are  you sure ?',
                    buttonsTextStyle: const TextStyle(color: Colors.black),
                    showCloseIcon: true,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {AuthService().signOut();
                    AuthService().delete();},
                  ).show();


                },
                color: Colors.blueGrey,
                text: "Delete Account",
                shape: GFButtonShape.pills,
                fullWidthButton: true,
              ),
              SizedBox(height: 10,),
              Text("Version No 1.1.9"),
              SizedBox(height: 10,),
              if (_isBannerAdReady)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
            ],
          ),
        ),
      ),
    );



}



}