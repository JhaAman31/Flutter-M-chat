import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_chat/Models/user_model.dart';
import 'package:m_chat/Screens/home_screen.dart';
import 'package:m_chat/Screens/login_screen.dart';

import 'package:m_chat/Utils/firebase_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, authSnapshot) {
//           if (authSnapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (authSnapshot.hasError) {
//             Fluttertoast.showToast(msg: "An error occurred. Please try again.");
//             return const Center(child: Text("Error occurred!"));
//           }
//           if (authSnapshot.hasData) {
//             // Fetch user data from Firestore
//             return StreamBuilder<DocumentSnapshot>(
//               stream: FirebaseUtils.usersCollection()
//                   .doc(authSnapshot.data!.uid)
//                   .snapshots(),
//               builder: (context, userSnapshot) {
//                 if (userSnapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (userSnapshot.hasError) {
//                   Fluttertoast.showToast(
//                       msg: "Failed to fetch user data. Please try again.");
//                   return const Center(child: Text("Error fetching user data!"));
//                 }
//                 if (userSnapshot.hasData && userSnapshot.data!.exists) {
//                   final userData = UserModel.fromMap(
//                       userSnapshot.data!.data() as Map<String, dynamic>);
//                   return HomeScreen(
//                     userModel: userData,
//                     user: authSnapshot.data!,
//                   );
//                 }
//                 return const Center(child: Text("User not found."));
//               },
//             );
//           }
//           return LoginScreen();
//         },
//       ),
//     );
//   }
// }
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          Fluttertoast.showToast(msg: "Failed to initialize Firebase.");
          return const Scaffold(
            body: Center(child: Text("Error initializing Firebase")),
          );
        }
        return _buildAuthStream(); // Call the existing StreamBuilder logic
      },
    );
  }

  Widget _buildAuthStream() {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (authSnapshot.hasError) {
            Fluttertoast.showToast(msg: "An error occurred. Please try again.");
            return const Center(child: Text("Error occurred!"));
          }
          if (authSnapshot.hasData) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseUtils.usersCollection()
                  .doc(authSnapshot.data!.uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (userSnapshot.hasError) {
                  Fluttertoast.showToast(
                      msg: "Failed to fetch user data. Please try again.");
                  return const Center(child: Text("Error fetching user data!"));
                }
                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                  final userData = UserModel.fromMap(
                      userSnapshot.data!.data() as Map<String, dynamic>);
                  return HomeScreen(
                    userModel: userData,
                    user: authSnapshot.data!,
                  );
                }
                return const Center(child: Text("User not found."));
              },
            );
          }
          return LoginScreen();
        },
      ),
    );
  }
}
