import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_chat/Screens/complete_profile_screen.dart';
import 'package:m_chat/Utils/firebase_utils.dart';

import '../Models/user_model.dart';
import '../Screens/home_screen.dart';

class AuthUtils {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static void createUser(
      BuildContext context, String email, String password) async {
    UserCredential? credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print("User Created");
    } on FirebaseAuthException catch (ex) {
      Fluttertoast.showToast(msg: "Error: ${ex.message}");
    }
    print("User is not null");
    if (credential != null) {
      String docId = credential.user!.uid;

      UserModel userModel = UserModel("", email, password, docId, "");

      FirebaseUtils.userReference().set(userModel.toMap());
      Fluttertoast.showToast(msg: "User Login Successful");
      navigateToCompleteProfileScreen(context, userModel, credential.user!);
    }
  }

  static void loginUser(
      BuildContext context, String email, String password) async {
    UserCredential? credential;
    try {
      credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      Fluttertoast.showToast(msg: "LogIn Error :  ${ex.message}");
    }
    if (credential != null) {
      // String docId = credential.user!.uid;

      DocumentSnapshot snapshot = await FirebaseUtils.userReference().get();
      UserModel model =
          UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      navigateToHomeScreen(context, model, credential.user!);
    }
  }

  static void navigateToHomeScreen(
      BuildContext context, UserModel model, User user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomeScreen(userModel: model, user: user);
    }));
  }

  static void navigateToCompleteProfileScreen(
      BuildContext context, UserModel userModel, User user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CompleteProfileScreen(userModel: userModel, user: user);
    }));
  }
}
