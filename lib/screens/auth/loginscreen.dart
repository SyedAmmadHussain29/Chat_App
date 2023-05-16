import 'package:chat_app/main.dart';
import 'package:chat_app/screens/auth/registrationscreen.dart';
import 'package:flutter/material.dart';

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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ));
                },
                icon: const Icon(Icons.phone),
                label: RichText(
                    text: const TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                      TextSpan(text: "Verify"),
                      TextSpan(
                          text: " Number",
                          style: TextStyle(fontWeight: FontWeight.w500))
                    ]))),
          )
        ],
      ),
    );
  }
}
