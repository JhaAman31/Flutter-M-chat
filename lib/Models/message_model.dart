class MessageModel {
  String? messageId;
  String? sender;
  String? message;
  DateTime? msgTime;
  bool? seen;

  MessageModel(
      this.messageId, this.sender, this.message, this.msgTime, this.seen);

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageId = map["MessageId"];
    sender = map["Sender"];
    message = map["Message"];
    msgTime = map["MsgTime"].toDate();
    seen = map["Seen"];
  }

  Map<String, dynamic> toMap() {
    return {
      "MessageId": messageId,
      "Sender": sender,
      "Message": message,
      "MsgTime": msgTime,
      "Seen": seen
    };
  }
}
