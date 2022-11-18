// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, prefer_const_literals_to_create_immutables, unnecessary_null_comparison

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/screen/authentication/signUp/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

//function for user SignIn with gmail and password
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
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
    log(userCredential.additionalUserInfo!.profile!.toString());
    // log(userCredential.additionalUserInfo!.profile!["name"].toString());
    // log(userCredential.additionalUserInfo!.profile!["email"].toString());
    // log(userCredential.additionalUserInfo!.profile!["picture"].toString());

    // //save profile picture in farebase datastore
    // try{

    // }catch (e){}

    return userCredential;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(title: Text("Login Screen")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "WELCOME",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Please enter your details",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  googleLogin();
                },
                child: Container(
                  padding:
                      EdgeInsets.only(left: 0, top: 10, bottom: 10, right: 0),
                  // width: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        "https://kgo.googleusercontent.com/profile_vrt_raw_bytes_1587515358_10512.png",
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Sign in with Google",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                // padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.black,
                      height: 1,
                      width: MediaQuery.of(context).size.width * .4,
                    ),
                    Text("or"),
                    Container(
                      color: Colors.black,
                      height: 1,
                      width: MediaQuery.of(context).size.width * .4,
                    ),
                  ],
                ),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Email"),
                controller: emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: "password"),
                controller: passwordController,
              ),
              SizedBox(height: 20),
              CupertinoButton(
                  padding: EdgeInsets.symmetric(horizontal: 110),
                  color: Colors.black,
                  child: Text("Log in"),
                  onPressed: () {
                    signIn();
                  }),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ));
                      },
                      child: Text(
                        "Sign up for free",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
