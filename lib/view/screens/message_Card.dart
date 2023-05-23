import 'package:chat_app/API/api.dart';
import 'package:chat_app/Model/message.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Aligns the message card to the left
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 221, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.msg,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.message.sent,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
          width: 10,
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Aligns the message card to the left
      children: [
        const SizedBox(
          height: 10,
          width: 10,
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 255, 178),
              border: Border.all(color: Colors.lightGreen),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30),
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message.msg,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.message.sent,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
