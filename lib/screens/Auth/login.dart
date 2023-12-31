import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/helper/color.dart';
import 'package:todo_app/helper/ui_helper.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/screens/Auth/signup.dart';
import 'package:todo_app/screens/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool show = false;

  // method for check value
  void checkValue() {
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    if (email == "") {
      log("Email can't be empty");
    } else if (password == "") {
      log("password can't be empty");
    } else {
      login(email, password);
    }
  }

  // method for login....
  void login(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseException catch (error) {
      log(error.code.toString());
    }
    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection("user").doc(uid).get();
      UserModel user =
          UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      log("user login successfully");
      if (!context.mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) {
        return HomeScreen(
          firebaseUser: userCredential!.user!,
          user: user,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: purpleCF9FFF,
          title: const Text("To-Do App"),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
            color: black,
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 30,
          ),
          child: Center(
            heightFactor: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  verticalSpaceMedium,
                  // for email address
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      hintText: "Enter Your Email Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  // for password
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: show ? true : false,
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      hintText: "Enter Your Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            if (show) {
                              show = false;
                            } else {
                              show = true;
                            }
                          });
                        },
                        icon: show
                            ? const Icon(
                                FontAwesomeIcons.solidEyeSlash,
                                color: purpleCF9FFF,
                                size: 18,
                              )
                            : const Icon(
                                Icons.remove_red_eye_rounded,
                                color: purpleCF9FFF,
                              ),
                      ),
                    ),
                  ),
                  verticalSpacesLarge,
                  CupertinoButton(
                    color: purpleCF9FFF,
                    child: const Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      checkValue();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Do have any account?",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              horizontalSpaceSmall,
              CupertinoButton(
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                      // fontSize: 15,
                      color: blue,
                    ),
                  ),
                  onPressed: () {
                    emailController.clear();
                    passwordController.clear();
                    Navigator.push(context, CupertinoPageRoute(
                      builder: (context) {
                        return const SignUpPage();
                      },
                    ));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
