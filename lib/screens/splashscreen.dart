import 'package:chat_app/main.dart';
import 'package:chat_app/screens/auth/loginscreen.dart';
import 'package:chat_app/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const loginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              right: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset("images/icon.png")),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: const Text(
                "SAM CHAT",
                style: TextStyle(
                    letterSpacing: 2,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ))
        ],
      ),
    );
  }
}
