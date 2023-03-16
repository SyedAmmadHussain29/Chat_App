import 'dart:math';

import 'package:chat_app/main.dart';
import 'package:chat_app/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  bool _isanimated = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isanimated = true;
      });
    });
  }

  handleGoogleBtnClick() {
    signInWithGoogle().then((user) {
      print("User: ${user.user}");
      print("\nUserAdditionlaInfo:${user.additionalUserInfo}");

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => const MyHomePage(title: "title")));
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  //Signout
  signout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
              duration: const Duration(seconds: 1),
              top: mq.height * .15,
              right: _isanimated ? mq.width * .25 : -mq.width * .5,
              width: mq.width * .5,
              child: SizedBox(
                  width: 500,
                  // height: mq.height,
                  child: Image.asset("images/icon.png"))),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 219, 255, 178),
                  shape: const StadiumBorder(),
                  elevation: 1,
                ),
                onPressed: () {
                  handleGoogleBtnClick();
                },
                icon: Image.asset(
                  "images/google.png",
                  height: mq.height * .03,
                ),
                label: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                      TextSpan(text: "Sign in"),
                      TextSpan(
                          text: " Google",
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]))),
          )
        ],
      ),
    );
  }
}
