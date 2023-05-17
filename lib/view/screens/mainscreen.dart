import 'dart:developer';
import 'package:chat_app/API/api.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:flutter/material.dart';
import 'chatusercard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<UserModel> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Main Screen"),
        ),
        body: StreamBuilder(
            stream: APIs.firestore.collection("users").snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                //if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator());

                //if data load so show
                case ConnectionState.active:
                case ConnectionState.done:
                  log("inbuilder");

                  final data = snapshot.data?.docs;

                  list =
                      data?.map((e) => UserModel.fromJson(e.data())).toList() ??
                          [];

                  if (list.isNotEmpty) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: list.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatUserCard(user: list[index]);
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Connections Not Found",
                        style: TextStyle(fontSize: 25),
                      ),
                    );
                  }
              }
            }));
  }
}
