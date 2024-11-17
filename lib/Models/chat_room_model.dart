import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {
  String? chatRoomId;
  Map<String,dynamic>? participants;
  String? lastMessage;
  DateTime? roomCreatedTime;

  ChatRoomModel(this.chatRoomId, this.participants, this.lastMessage,this.roomCreatedTime);

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatRoomId = map["ChatRoomId"];
    participants = map["Participants"];
    lastMessage = map["LastMessage"];
    map["RoomCreatedTime"] != null
        ? (map["RoomCreatedTime"] as Timestamp).toDate()
        : null;;
  }

  Map<String, dynamic> toMap() {
    return {
      "ChatRoomId": chatRoomId,
      "Participants": participants,
      "LastMessage": lastMessage,
      "RoomCreatedTime":roomCreatedTime
    };
  }
}
