import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_chat/Models/user_model.dart';
import 'package:m_chat/Screens/home_screen.dart';
import 'package:m_chat/Utils/GetFirebaseData.dart';
import 'package:m_chat/Utils/auth_utils.dart';
import 'package:m_chat/Utils/firebase_utils.dart';

class CompleteProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User user;

  const CompleteProfileScreen(
      {Key? key, required this.userModel, required this.user})
      : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  File? imageFile;
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.lightBlueAccent,
                    child: (imageFile == null)
                        ? const Icon(
                            Icons.person,
                            size: 65,
                          )
                        : GetFirebaseData.base64ToImage(imageFile.toString()),
                  ),
                  onPressed: () {
                    selectImgSource();
                  }),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                // cursorColor: Colors.bl,
                decoration: const InputDecoration(
                    hintText: "Enter your full name",
                    prefixIcon: Icon(
                      Icons.person,
                      // color: Colors.blueAccent,
                    ),
                    label: Text("Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              CupertinoButton(
                  color: Colors.black,
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    checkValidation();
                  })
            ],
          ),
        ),
      ),
    );
  }

  void selectImgSource() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: const Icon(Icons.chat),
            title: const Text("Upload profile picture..."),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_album_outlined),
                  title: const Text("Select from Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take a Photo"),
                  // onTap: ,
                )
              ],
            ),
          );
        });
  }

  void selectImage(ImageSource source) async {
    XFile? selectedImg = await ImagePicker().pickImage(source: source);
    if (selectedImg != null) {
      cropImage(selectedImg);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 50);
    if (croppedFile != null) {
      setState(() {
        imageFile = File(croppedFile.path);
      });
    }
  }

  void checkValidation() {
    String name = nameController.text.trim();
    if (imageFile == null || name.isEmpty) {
      Fluttertoast.showToast(msg: "Fill all the details");
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    try {
      String name = nameController.text.trim();

      // Convert the image file to a base64 string
      List<int> imageBytes = await imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Create a Firestore document with the name and base64 image

      widget.userModel.name = name;
      widget.userModel.profilePic = base64Image;

      FirebaseUtils.userReference()
          .set(widget.userModel.toMap())
          .then((onValue) {
        Fluttertoast.showToast(msg: "Data uploaded successfully!");
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen(userModel: widget.userModel, user: widget.user);
        }));
        setState(() {
          imageFile = null;
          nameController.clear();
        });
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error uploading data: $e");
    }
  }
}
