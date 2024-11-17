import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_chat/Models/chat_room_model.dart';
import 'package:m_chat/Models/user_model.dart';
import 'package:m_chat/Screens/chat_screen.dart';
import 'package:m_chat/Screens/main.dart';
import 'package:m_chat/Utils/GetFirebaseData.dart';
import 'package:m_chat/Utils/firebase_utils.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const SearchScreen({super.key, required this.userModel, required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchedQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search your Friends"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                setState(() {
                  searchedQuery = value.trim();
                });
              },
              decoration: const InputDecoration(
                label: Text("Name"),
                hintText: "e.g : Goku",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: searchedQuery.isEmpty
                  ? FirebaseUtils.usersCollection().snapshots()
                  : FirebaseUtils.usersCollection()
                      .where("Name", isEqualTo: searchedQuery)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueAccent,
                    ),
                  );
                } else if (snapshot.hasError) {
                  Fluttertoast.showToast(msg: "Some error has occurred");
                  return const Center(
                    child: Text(
                      "An error occurred. Please try again.",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No user found"));
                } else {
                  List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> map =
                          docs[index].data() as Map<String, dynamic>;
                      UserModel searchedUser = UserModel.fromMap(map);

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          onTap: () async {
                            ChatRoomModel chatRoomModel =
                                await getOrCreateChatRoom(searchedUser);
                            if (chatRoomModel != null) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChatScreen(
                                    userModel: widget.userModel,
                                    otherUser: searchedUser,
                                    chatRoomModel: chatRoomModel,
                                    user: widget.user);
                              }));
                            }
                          },
                          title: (searchedUser.userId == widget.user.uid)
                              ? Text("${searchedUser.name}. (You)")
                              : Text(searchedUser.name.toString()),
                          subtitle: Text(searchedUser.email!),
                          leading: CircleAvatar(
                            child: searchedUser.profilePic == null ||
                                    searchedUser.profilePic!.isEmpty
                                ? const Icon(Icons.person)
                                : GetFirebaseData.base64ToImage(
                                    searchedUser.profilePic),
                          ),
                          trailing: const CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            child: Icon(Icons.chat),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Future<ChatRoomModel> getOrCreateChatRoom(UserModel otherUser) async {
    ChatRoomModel? chatRoomModel;
    QuerySnapshot snapshot = await FirebaseUtils.chatRoomCollection()
        .where("Participants.${widget.userModel.userId}", isEqualTo: true)
        // .where("Participants.${otherUser.userId}", isEqualTo: true)
        .get();
    if (snapshot.docs.length > 0) {
      var docRoom = snapshot.docs[0].data();
      ChatRoomModel existingRoom =
          ChatRoomModel.fromMap(docRoom as Map<String, dynamic>);
      chatRoomModel = existingRoom;
    } else {
      ChatRoomModel newChatRoom = ChatRoomModel(
          uuid.v1(),
          {
            widget.user.uid.toString(): true,
            otherUser.userId.toString(): true,
          },
          "",
          DateTime.now());
      await FirebaseUtils.chatRoomCollection()
          .doc(newChatRoom.chatRoomId)
          .set(newChatRoom.toMap());
      chatRoomModel = newChatRoom;
    }
    return chatRoomModel;
  }
}
