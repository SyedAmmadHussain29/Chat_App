import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/API/api.dart';
import 'package:chat_app/Model/message.dart';
import 'package:chat_app/main.dart';
import 'package:flutter/material.dart';

import '../others/my_date_utils.dart';

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
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      log("message read time update");
    }
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Aligns the message card to the left
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
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
                widget.message.type == Type.text
                    ? Text(
                        widget.message.msg,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: mq.height * .3,
                          imageUrl: widget.message.msg,
                          // placeholder: (context, url) =>const CircularProgressIndicator(strokeWidth: 2,),
                          errorWidget: (context, url, error) => Icon(
                            Icons.image,
                            size: 70,
                          ),
                        ),
                      ),
                const SizedBox(height: 7),
                Text(
                  MyDateUtil.getFormattedTime(
                      context: context, time: widget.message.sent),
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
          MainAxisAlignment.end, // Aligns the message card to the left
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 255, 149),
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
                widget.message.type == Type.text
                    ? Text(
                        widget.message.msg,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: widget.message.msg,
                          height: mq.height * .3,
                          // placeholder: (context, url) =>
                          // const CircularProgressIndicator(
                          // strokeWidth: 2,
                          // ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.image,
                            size: 70,
                          ),
                        ),
                      ),
                const SizedBox(height: 7),
                Text(
                  MyDateUtil.getFormattedTime(
                      context: context, time: widget.message.sent),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        if (widget.message.read.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: const Icon(
              Icons.done_all_rounded,
              size: 17,
            ),
          ),
      ],
    );
  }
}
