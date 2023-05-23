import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Model/user_model.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/view/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final UserModel user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: EdgeInsets.symmetric(
          vertical: 4, horizontal: MediaQuery.of(context).size.width * 0.02),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  user: widget.user,
                ),
              ));
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              height: mq.height * .055,
              width: mq.height * .055,
              imageUrl: widget.user.image,
              //placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          title: Text(widget.user.name),
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          trailing: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
