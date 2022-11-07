// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  //function for create account
  void createAccount() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmpassword = confirmpasswordController.text.trim();

    if (email == "" || password == "" || confirmpassword == "") {
      log("Enter correct credencials ");
    } else if (password != confirmpassword) {
      log("Enter correct password ");
    }
    //create account
    else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          log("User Created ");
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        log(e.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignUp Screen")),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email "),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "password "),
                ),
                TextField(
                  controller: confirmpasswordController,
                  decoration: InputDecoration(labelText: "confirm password "),
                ),
                CupertinoButton(
                    child: Text("SignUp"),
                    onPressed: () {
                      createAccount();
                    }),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
