import 'package:chat_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'view/screens/splashscreen.dart';

late Size mq;
//Future<void> backgroundHandler(RemoteMessage message) async {}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    runApp(MyApp());
  });

  //await FirebaseMessaging.instance.getInitialMessage();
  //FirebaseMessaging.onBackgroundMessage(backgroundHandler);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen()
        //MainScreen()
        );
  }
}

Future<void> initializeFirebase() async {
  print("Firebase initialized");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
