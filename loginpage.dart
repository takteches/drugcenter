import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:getwidget/components/button/gf_social_button.dart';
import 'package:rwakd_adwyh/ui.dart';
import 'package:rwakd_adwyh/wrapper.dart';
import 'package:social_login_buttons/social_login_buttons.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("رواكد أدويه",
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 10),

          Container(
            width: 50,
            height: 50 ,
            child:Image.asset("assets/giphy.gif"),
          ),
          const SizedBox(height: 50),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SocialLoginButton(
                buttonType: SocialLoginButtonType.google,
                borderRadius: 20,
                fontSize: 25,
                height: 50,
                onPressed: () {
                  AuthService().signInWithGoogle();
                },
              ),
              const SizedBox(height: 10),
              SocialLoginButton(
                backgroundColor: Colors.blueGrey,
                height: 50,
                text: 'login as aguest',
                borderRadius: 20,
                fontSize: 25,
                buttonType: SocialLoginButtonType.generalLogin,
                onPressed: () {
                  AuthService().signInWithguest();
                },
              ),




            ],
          ),
        ],
      ),
    );
  }
}