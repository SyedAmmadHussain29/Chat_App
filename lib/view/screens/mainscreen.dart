import 'dart:developer';
import 'package:chat_app/API/api.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/view/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chatusercard.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<UserModel> _list = [];
  final List<UserModel> _Searchlist = [];
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context)..unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            appBar: AppBar(
              leading: const Icon(Icons.home),
              title: _isSearching
                  ? TextField(
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Name, Email .."),
                      autofocus: true,
                      style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                      onChanged: (val) {
                        //search logic
                        _Searchlist.clear();
                        for (var i in _list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase())) {
                            _Searchlist.add(i);
                            setState(() {
                              _Searchlist;
                            });
                          }
                        }
                      },
                    )
                  : const Text("Main Screen"),
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                      });
                    },
                    icon: Icon(_isSearching
                        ? CupertinoIcons.clear_circled_solid
                        : Icons.search)),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfileScreen(user: APIs.me)));
                    },
                    icon: const Icon(Icons.more_vert)),
              ],
            ),
            body: StreamBuilder(
                stream: APIs.getAllUsers(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: CircularProgressIndicator());

                    //if data load so show
                    case ConnectionState.active:
                    case ConnectionState.done:
                      log("inbuilder");

                      final data = snapshot.data?.docs;

                      _list = data
                              ?.map((e) => UserModel.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount:
                              _isSearching ? _Searchlist.length : _list.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                                user: _isSearching
                                    ? _Searchlist[index]
                                    : _list[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "Connections Not Found",
                            style: TextStyle(fontSize: 25),
                          ),
                        );
                      }
                  }
                })),
      ),
    );
  }
}
