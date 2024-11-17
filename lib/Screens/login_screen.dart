import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_chat/Screens/register_screen.dart';
import 'package:m_chat/Utils/auth_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoButton(
                onPressed: () {},
                child: const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.chat,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: emailCont,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    hintText: "Enter your e-mail",
                    prefixIcon: Icon(
                      Icons.email,
                      // color: Colors.blueAccent,
                    ),
                    label: Text("Email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    )),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                    hintText: "Enter your password",
                    prefixIcon: Icon(
                      Icons.lock,
                      // color: Colors.blueAccent,
                    ),
                    label: Text("Password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              CupertinoButton(
                  child: Text("Login",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                  // borderRadius: BorderRadius.all(18),
                  color: Colors.white,
                  onPressed: () {})
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "New User?",
            style: TextStyle(fontSize: 17,color: Colors.white),
          ),
          CupertinoButton(
              child: const Text(
                "Register here",
                style: TextStyle(color: Colors.amberAccent,fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                navigateToRegister();
              })
        ],
      ),
    );
  }

  void checkValidation() {
    String email = emailCont.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Fill all the fields");
    } else {
      userLogin(email, password);
    }
  }

  void navigateToRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterScreen()));
  }

  void userLogin(String email, String password) {
    AuthUtils.loginUser(context, email, password);
  }
}
