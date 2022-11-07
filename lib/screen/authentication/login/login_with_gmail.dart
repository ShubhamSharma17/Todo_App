// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/screen/addList/add_list_screen.dart';
import 'package:todo_app/screen/authentication/signUp/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
//function for user SignIn
  void signIn() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "" || password == "") {
      log("Enter Correct Data");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          log("Sign in successful");
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => HomeScreen(),
              ));
        }
      } on FirebaseAuthException catch (e) {
        log(e.code.toString());
      }
    }
  }

  //funtion for google signIn
  googleLogin() async {
    //trigger the authentication flow
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();

    //obtain the auth detain from the request
    final GoogleSignInAuthentication googleAuth =
        await googleSignInAccount!.authentication;

    //create a new cradencial
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (credential != null) {
      // log("while screen Change ");
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }

    // log(userCredential.toString());
    // log(userCredential.additionalUserInfo!.profile!.toString());
    log(userCredential.additionalUserInfo!.profile!["name"].toString());
    log(userCredential.additionalUserInfo!.profile!["email"].toString());
    // return userCredential;
  }

  //function for google logout
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email"),
                  controller: emailController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: "password"),
                  controller: passwordController,
                ),
                CupertinoButton(
                    child: Text("Login"),
                    onPressed: () {
                      signIn();
                    }),
                CupertinoButton(
                  child: Text("Create Account"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(),
                        ));
                  },
                  color: Colors.grey,
                ),
                SizedBox(height: 15),
                TextButton(
                    onPressed: () {
                      googleLogin();
                    },
                    child: Text("SignIn with Google")),
                TextButton(
                    onPressed: () {
                      signOut();
                    },
                    child: Text("Sign out"))
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
