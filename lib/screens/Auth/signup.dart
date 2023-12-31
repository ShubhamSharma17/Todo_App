import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_app/helper/color.dart';
import 'package:todo_app/helper/ui_helper.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/screens/home.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool show = false;

  // method for checking values
  void checkValue() {
    String name = nameController.text.toString();
    String phoneNumber = phoneController.text.toString();
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    if (name == "") {
      log("Name can't be empty");
    } else if (phoneNumber == "") {
      log("Phone can't be empty");
    } else if (email == "") {
      log("email can't be empty");
    } else if (password == "") {
      log("password can't be empty");
    } else {
      signUp(email, password);
    }
  }

  // method for sign up
  void signUp(String email, String password) async {
    UserCredential? userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseException catch (error) {
      log(error.code.toString());
    }
    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      UserModel userModel = UserModel(
        email: emailController.text,
        name: nameController.text,
        uid: uid,
        phoneNumber: phoneController.text,
        noteID: "",
      );
      await FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .set(userModel.toMap())
          .then((value) {
        Navigator.popUntil(context, (route) {
          return route.isFirst;
        });
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) {
          return HomeScreen(
            user: userModel,
            firebaseUser: userCredential!.user!,
          );
        }));
      });

      log("user has been creadted!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: purpleCF9FFF,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "ToDo App",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  verticalSpaceMedium,
                  // for name
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.person,
                        color: purpleCF9FFF,
                      ),
                      labelText: "Enter name",
                      hintText: "Enter your full name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  // for phone number
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: "Enter Phone Number",
                      hintText: "Enter your Phone Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(
                        Icons.phone,
                        color: purpleCF9FFF,
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  // for email
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Enter email address",
                      hintText: "Enter your email addressr",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(
                        Icons.email,
                        color: purpleCF9FFF,
                      ),
                    ),
                  ),
                  verticalSpaceMedium,
                  // for password
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: show ? false : true,
                    decoration: InputDecoration(
                      labelText: "Enter password",
                      hintText: "Enter your password",
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
                      "Sign Up",
                      style: TextStyle(fontSize: 20),
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
      ),
    );
  }
}
