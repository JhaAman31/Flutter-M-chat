import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m_chat/Models/chat_room_model.dart';
import 'package:m_chat/Models/user_model.dart';
import 'package:m_chat/Screens/chat_screen.dart';
import 'package:m_chat/Screens/login_screen.dart';
import 'package:m_chat/Screens/search_screen.dart';
import 'package:m_chat/Utils/GetFirebaseData.dart';
import 'package:m_chat/Utils/firebase_utils.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const HomeScreen({super.key, required this.userModel, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.home),
        title: const Text("M-Chat"),
        actions: [
          CupertinoButton(
              child: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                navigateToSearchScreen(context, widget.userModel, widget.user);
              }),
          CupertinoButton(
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginScreen();
                }));
              }),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseUtils.chatRoomCollection()
              .where("Participants.${widget.userModel.userId}", isEqualTo: true)
              // .orderBy("RoomCreatedTime",descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                QuerySnapshot snap = snapshot.data as QuerySnapshot;
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 3),
                    itemCount: snap.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel roomModel = ChatRoomModel.fromMap(
                          snap.docs[index].data() as Map<String, dynamic>);

                      Map<String, dynamic> participantKeys =
                          roomModel.participants!;
                      List<String> participants = participantKeys.keys.toList();
                      participants.remove(widget.userModel.userId);

                      return FutureBuilder(
                          future: GetFirebaseData.getCurrentUserDetails(
                              participants[0]),
                          builder: (context, futureData) {
                            if (futureData.connectionState ==
                                ConnectionState.done) {
                              if (futureData.hasData) {
                                  UserModel targetUser = futureData.data as UserModel;

                                  return  Card(
                                    margin:const  EdgeInsets.symmetric(horizontal: 6,vertical: 2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    child: InkWell(
                                      child: ListTile(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) {
                                            return ChatScreen(
                                                userModel: widget.userModel,
                                                otherUser: targetUser,
                                                chatRoomModel: roomModel,
                                                user: widget.user);
                                          }));
                                        },
                                        leading: CircleAvatar(
                                          child: GetFirebaseData.base64ToImage(
                                              targetUser.profilePic),
                                        ),
                                        title: (targetUser.userId ==
                                                widget.userModel.userId)
                                            ? Text("${targetUser.name} (You)")
                                            : Text(targetUser.name.toString()),
                                        subtitle:  (roomModel.lastMessage.toString() != "") ? Text(roomModel.lastMessage.toString()) : const Text("Say hii to your new friend!", style: TextStyle(
                                          color: Colors.blueAccent,
                                        ),),
                                      ),
                                    ),
                                  );
                              } else if (futureData.hasError) {
                                return Center(
                                  child: Text(futureData.error.toString()),
                                );
                              } else {
                                return const Center(
                                  child: Text("No Chats"),
                                );
                              }
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          });
                    });
              } else {
                return Container();
              }
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  void navigateToSearchScreen(
      BuildContext context, UserModel userModel, User user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchScreen(
        userModel: userModel,
        user: user,
      );
    }));
  }
}
