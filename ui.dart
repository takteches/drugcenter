import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:getwidget/getwidget.dart';
import 'package:rwakd_adwyh/chat.dart';
import 'package:rwakd_adwyh/post.dart';
import 'package:rwakd_adwyh/listpage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';



import 'adhelper.dart';
import 'tabview.dart';
import 'addpage.dart';
import 'home.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {


  @override

  final List<Widget> _tabItems = [ addpage(), Sera_go(),my_post(),HomePage(),TabView()];
  int _activePage = 1;
  int _page = 0;
  int count = 0;
  String id=FirebaseAuth.instance.currentUser!.uid;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title// description
    importance: Importance.max,
    enableVibration: true,
  );
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;
  bool _isInterstitialAdLoaded = false;





  void loadFCM() async {
    if (!kIsWeb) {
      var channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.max,
        enableVibration: true,
      );

      var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }



  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }


  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data["badge"]}');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      setState(() {
        var test= int.parse(message.data["badge"]);
        assert(test is int);
        print(test);
        print(test.runtimeType);
        count += test  ;
        print(count);

      });

      if (notification != null && android != null && !kIsWeb) {

        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: "notification",
            ),
          ),
        );
      }

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }


  @override
  void initState() {
    intload();
    // TODO: implement initState
    super.initState();
    requestPermission();
    listenFCM();

  }
  void dispose() {

    _interstitialAd?.dispose();

    super.dispose();


  }
  void intload(){
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('$ad onAdDismissedFullScreenContent.');
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );}

  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        bottomNavigationBar:  CurvedNavigationBar(
                key: _bottomNavigationKey,
                index:1,
                height: 60.0,
                items: <Widget>[
                  Icon(Icons.add, size: 30),
                  Icon(Icons.list, size: 30),
                  Icon(Icons.delete, size: 30),
                  Icon(Icons.perm_identity, size: 30),
                  GFIconBadge(child:Icon(Icons.chat), counterChild: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                    alignment: Alignment.center,
                    child: Text(count.toString(),style: TextStyle(
                      color: Colors.white,
                    ),),
                  ),)

                ],
                color: Colors.blueGrey,
                buttonBackgroundColor: Colors.white,
                backgroundColor: Colors.grey.shade300,
                animationCurve: Curves.easeInOut,
                animationDuration: Duration(milliseconds: 600),
                onTap: (index) {
                  setState(() {
                    _activePage = index;
                    if(index==4){
                      count=0;
                      if (_isInterstitialAdReady) {
                        _interstitialAd?.show().then((shown) {
                          setState(() {
                            this._interstitialAd=null;
                            intload();
                            return null;
                          });
                        }).onError((error, stackTrace) {
                          debugPrint("Error showing Interstitial ad: $error");

                        });

                      }
                    }

                  });
                },
                letIndexChange: (index) => true,
              ),

        body: _tabItems[_activePage],
    );
  }
}
