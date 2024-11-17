import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_chat/Utils/auth_utils.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController confirmPwdController = TextEditingController();

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
                  backgroundColor: Colors.white,
                  radius: 60,
                  child: Icon(
                    Icons.chat,
                    size: 60,
                    // color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              TextField(
                controller: emailController,
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
                controller: pwdController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
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
                height: 15,
              ),
              TextField(
                controller: confirmPwdController,
                keyboardType: TextInputType.visiblePassword,
                // obscureText: true,
                decoration: const InputDecoration(
                    hintText: "Re-Enter your password",
                    prefixIcon: Icon(
                      Icons.remove_red_eye,
                      // color: Colors.blueAccent,
                    ),
                    label: Text("Confirm password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    )),
              ),
              const SizedBox(
                height: 50,
              ),
              CupertinoButton(
                  child: Text("Register",style: TextStyle(color: Colors.black),),
                  // borderRadius: BorderRadius.all(18),
                  color: Colors.white,
                  onPressed: () {
                    checkValidation();
                  })
            ],
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Already have an Account?",
            style: TextStyle(fontSize: 17,color: Colors.white),
          ),
          CupertinoButton(
              child: const Text(
                "Log In",
                style: TextStyle(color: Colors.amberAccent),
              ),
              onPressed: () {
                navigateToLogin();
              })
        ],
      ),
    );
  }

  void navigateToLogin() {
    Navigator.pop(context);
  }

  void checkValidation() {
    String email = emailController.text.trim();
    String password = pwdController.text.trim();
    String confirmPwd = confirmPwdController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPwd.isEmpty) {
      Fluttertoast.showToast(msg: "Enter the details first");
    } else if (confirmPwd != password) {
      Fluttertoast.showToast(msg: "Password is mismatched");
    } else {
      registerUser(email, password);
    }
  }

  void registerUser(String email, String password) {
    AuthUtils.createUser(context, email, password);

  }
}
