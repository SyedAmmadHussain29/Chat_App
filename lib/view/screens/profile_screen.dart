import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/API/api.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/controller/auth/login_screen.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/view/others/Dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile Screen"),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  Center(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .1),
                          child: CachedNetworkImage(
                            height: mq.height * .2,
                            width: mq.height * .2,
                            fit: BoxFit.contain,
                            imageUrl: widget.user.image,
                            //placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            onPressed: () {
                              _showbuttonsheet();
                            },
                            color: Colors.white,
                            elevation: 1,
                            shape: CircleBorder(),
                            child: Icon(Icons.edit, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  Text(
                    widget.user.email,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (val) => APIs.me.name = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "eg: Jonny",
                      label: Text("Name"),
                    ),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .02,
                  ),
                  TextFormField(
                    initialValue: widget.user.about,
                    onSaved: (val) => APIs.me.about = val ?? "",
                    validator: (val) =>
                        val != null && val.isNotEmpty ? null : "Required Field",
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.info_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "Feeling Happy",
                      label: Text("About"),
                    ),
                  ),
                  SizedBox(
                    width: mq.width,
                    height: mq.height * .03,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        minimumSize: Size(mq.width * .4, mq.height * .05)),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                        APIs.UpdateUserInfo().then((value) {
                          Dialogs.showSnackbar(context, "Profile Updaed");
                        });
                      }
                    },
                    icon: Icon(Icons.update),
                    label: Text("UPDATE"),
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Dialogs.showProgressBar(context);
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) => {
                    Navigator.pop(context),
                    Navigator.pop(context),
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginScreen(),
                        ))
                  });
            });
            //APIs.auth.signOut();
            //GoogleSignIn().signOut();
          },
          label: Text("Logout"),
          icon: Icon(Icons.logout),
        ),
      ),
    );
  }

  void _showbuttonsheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20))),
      builder: (_) {
        return ListView(
          padding:
              EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
          shrinkWrap: true,
          children: [
            Center(
              child: Text(
                "Pick Profile Picture",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.white,
                        fixedSize: Size(mq.width * .3, mq.height * .15)),
                    onPressed: () {},
                    child: Image.asset("images/addimage.png")),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.white,
                        fixedSize: Size(mq.width * .3, mq.height * .15)),
                    child: Image.asset("images/cameraimage.png")),
              ],
            ),
          ],
        );
      },
    );
  }
}
