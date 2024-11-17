import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:m_chat/Models/user_model.dart';

class GetFirebaseData {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> getCurrentUserDetails(String userId) async {
    UserModel? model;
    DocumentSnapshot snapshot = await _firestore.collection("Users").doc(userId).get();
    if (snapshot.data() != null) {
      model = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }
    return model;
  }

  static Widget base64ToImage(String? base64String,
      {double width = 40, double height = 40}) {
    if (base64String == null || base64String.isEmpty) {
      // Return a default placeholder if base64String is null or empty
      return const Icon(Icons.person, size: 40);
    }

    try {
      // Decode base64 string to bytes and create an Image widget
      final imageBytes = base64Decode(base64String);
      return ClipOval(
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
      );
    } catch (e) {
      // If decoding fails, return a placeholder icon
      return const Icon(Icons.error, size: 40);
    }
  }
}
