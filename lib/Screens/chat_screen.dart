import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_chat/Models/chat_room_model.dart';
import 'package:m_chat/Models/message_model.dart';
import 'package:m_chat/Models/user_model.dart';
import 'package:m_chat/Screens/main.dart';
import 'package:m_chat/Utils/GetFirebaseData.dart';
import 'package:m_chat/Utils/firebase_utils.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userModel;
  final UserModel otherUser;
  final ChatRoomModel chatRoomModel;
  final User user;

  const ChatScreen(
      {Key? key,
      required this.userModel,
      required this.otherUser,
      required this.chatRoomModel,
      required this.user})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                child: widget.otherUser.profilePic == null ||
                        widget.otherUser.profilePic!.isEmpty
                    ? Icon(Icons.person)
                    : GetFirebaseData.base64ToImage(
                        widget.otherUser.profilePic),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(widget.otherUser.name.toString()),
            ],
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: StreamBuilder(
                      stream: FirebaseUtils.chatRoomCollection()
                          .doc(widget.chatRoomModel.chatRoomId)
                          .collection("Messages")
                          .orderBy("MsgTime", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          if (snapshot.hasData) {
                            QuerySnapshot docQuery =
                                snapshot.data as QuerySnapshot;
                            return ListView.builder(
                                reverse: true,
                                itemCount: docQuery.docs.length,
                                itemBuilder: (context, index) {
                                  MessageModel msgModel = MessageModel.fromMap(
                                      docQuery.docs[index].data()
                                          as Map<String, dynamic>);
                                  return Row(
                                    mainAxisAlignment: (msgModel.sender ==
                                            widget.userModel.userId)
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 2.5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: (msgModel.sender ==
                                                    widget.userModel.userId)
                                                ? Colors.blueAccent
                                                : Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            msgModel.message.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          )),
                                    ],
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text("Please check your connection"));
                          } else {
                            return const Center(
                                child: Text("Send a welcome message"));
                          }
                        }
                      }),
                ),
              )),
              Container(
                color: Colors.grey.shade400,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: Row(
                    children: [
                      Flexible(
                          child: TextField(
                        controller: messageController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write something..."),
                      )),
                      IconButton(
                          onPressed: () {
                            sendMessage();
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blueAccent,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void sendMessage() {
    String message = messageController.text.trim();
    messageController.clear();
    if (message.isNotEmpty) {
      MessageModel messageModel = MessageModel(
          uuid.v1(), widget.user.uid, message, DateTime.now(), false);
      FirebaseUtils.messageCollection(
              widget.chatRoomModel.chatRoomId.toString())
          .doc(messageModel.messageId)
          .set(messageModel.toMap());

      widget.chatRoomModel.lastMessage = message;
      widget.chatRoomModel.roomCreatedTime = DateTime.now();
      FirebaseUtils.chatRoomCollection()
          .doc(widget.chatRoomModel.chatRoomId)
          .set(widget.chatRoomModel.toMap());
    }
  }
}
