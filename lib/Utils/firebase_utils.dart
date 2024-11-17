import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FirebaseUtils {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static DocumentReference userReference() {
    return _firestore.collection("Users").doc(_auth.currentUser!.uid);
  }

  static CollectionReference usersCollection() {
    return _firestore.collection("Users");
  }

  static CollectionReference chatRoomCollection(){
    return _firestore.collection("ChatRooms");
  }

  static CollectionReference messageCollection(String chatroomId){
    return _firestore.collection("ChatRooms").doc(chatroomId).collection("Messages");
  }
}
