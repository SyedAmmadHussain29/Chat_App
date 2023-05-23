import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/API/api.dart';
import 'package:chat_app/Model/message.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/view/screens/message_Card.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;
  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  //for messages controller
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(children: [
          Expanded(
            child: StreamBuilder(
                stream: APIs.getAllMessages(widget.user),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    //if data is loading
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(child: SizedBox());

                    //if data load so show
                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                          [];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _list.length,
                          padding: EdgeInsets.only(top: mq.height * .01),
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(
                              message: _list[index],
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "Say Hi",
                            style: TextStyle(fontSize: 25),
                          ),
                        );
                      }
                  }
                }),
          ),
          _chatInput(),
        ]),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
              )),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              height: mq.height * .05,
              width: mq.height * .05,
              imageUrl: widget.user.image,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.user.name,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "Last seen not available",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .015),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              elevation: 2,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Colors.blue,
                      )),
                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none),
                  )),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.image,
                        color: Colors.blue,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.blue,
                      )),
                  SizedBox(
                    width: mq.width * .02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = "";
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            shape: CircleBorder(),
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
