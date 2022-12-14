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
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.yellow[600],
        backgroundColor: Theme.of(context).primaryColor,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //image
                          Center(
                            child: Container(
                                height: 150,
                                child:
                                    Image.asset('assets/images/welcome.png')),
                          ),
                          SizedBox(height: 20),

                          //some text here'
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Login",
                                style: TextStyle(fontSize: 40),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Please enter your details",
                              ),
                            ],
                          ),

                          // email text feild
                          ClipRRect(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 15, top: 1, right: 1, left: 1),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 0, bottom: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 1), //(x,y)
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                controller: emailController,
                              ),
                            ),
                          ),

                          // for password text feild
                          ClipRRect(
                            child: Container(
                              margin: const EdgeInsets.only(
                                  bottom: 45, top: 1, right: 1, left: 1),
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 0, bottom: 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 1), //(x,y)
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  border: InputBorder.none,
                                  labelStyle: TextStyle(color: Colors.black),
                                ),
                                controller: emailController,
                              ),
                            ),
                          ),
                        ],
                      ),
                      //signIn button
                      FloatingActionButton(
                        backgroundColor: Theme.of(context).primaryColor,
                        elevation: 3,
                        child: Icon(Icons.arrow_forward_rounded),
                        onPressed: () => signIn(),
                      ),
                    ],
                  ),
                ),
              ),

              // for dividing the main container
              Positioned(
                bottom: 250,
                right: -10,
                left: -10,
                child: Transform.rotate(
                  angle: .25,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),

              // create signup button and google button
              Positioned(
                bottom: MediaQuery.of(context).size.height * .01,
                left: 0,
                right: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(fontSize: 16),
                        ),
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: SizedBox(
                          child: Text("or", style: TextStyle(fontSize: 20))),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        googleLogin();
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 45,
                          right: 45,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(),
                          color: Colors.white,
                        ),
                        child: Image.network(
                          "https://kgo.googleusercontent.com/profile_vrt_raw_bytes_1587515358_10512.png",
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    // return SafeArea(
    //   child: Scaffold(
    //     backgroundColor: Colors.blueGrey[100],
    //     resizeToAvoidBottomInset: false,
    //     // appBar: AppBar(title: Text("Login Screen")),
    //     body: SingleChildScrollView(
    //       physics: BouncingScrollPhysics(),
    //       child: GestureDetector(
    //         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
    //         child: Padding(
    //           padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               Text(
    //                 "WELCOME",
    //                 style: TextStyle(
    //                   fontSize: 50,
    //                   fontWeight: FontWeight.bold,
    //                 ),
    //               ),
    //               SizedBox(height: 10),
    //               Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Container(
    //                     clipBehavior: Clip.antiAlias,
    //                     decoration: BoxDecoration(
    //                         border: Border.all(color: Colors.transparent),
    //                         borderRadius: BorderRadius.circular(40)),
    //                     child: Image(
    //                       image: AssetImage(
    //                           "assets/images/undraw_Login_re_4vu2.png"),
    //                     ),
    //                   ),
    //                   // SizedBox(height: 30),
    //                   Text(
    //                     "Please enter your details",
    //                     style: TextStyle(
    //                       fontSize: 17,
    //                       fontWeight: FontWeight.w400,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(height: 10),
    //               Container(
    //                 padding:
    //                     EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(40),
    //                     border: Border.all()),
    //                 child: TextField(
    //                   keyboardType: TextInputType.emailAddress,
    //                   decoration: InputDecoration(
    //                     labelText: "Email",
    //                     border: InputBorder.none,
    //                     labelStyle: TextStyle(color: Colors.black),
    //                   ),
    //                   controller: emailController,
    //                 ),
    //               ),
    //               SizedBox(height: 10),
    //               Container(
    //                 padding:
    //                     EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
    //                 decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(40),
    //                     border: Border.all()),
    //                 child: TextField(
    //                   decoration: InputDecoration(
    //                     labelText: "password",
    //                     border: InputBorder.none,
    //                     labelStyle: TextStyle(color: Colors.black),
    //                   ),
    //                   controller: passwordController,
    //                 ),
    //               ),
    //               SizedBox(height: 20),
    //               CupertinoButton(
    //                   padding: EdgeInsets.symmetric(horizontal: 110),
    //                   color: Theme.of(context).primaryColor,
    //                   // color: Colors.amber[400],
    //                   child: Text(
    //                     "Log in",
    //                     style: TextStyle(
    //                       color: Colors.black,
    //                       fontSize: 20,
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     signIn();
    //                   }),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Text("Don't have an account?"),
    //                   TextButton(
    //                       onPressed: () {
    //                         Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                               builder: (context) => SignUpScreen(),
    //                             ));
    //                       },
    //                       child: Text(
    //                         "Sign up for free",
    //                         style: TextStyle(color: Colors.black),
    //                       ))
    //                 ],
    //               ),
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Container(
    //       color: Colors.black,
    //       height: 1,
    //       width: MediaQuery.of(context).size.width * .4,
    //     ),
    //     Text("or"),
    //     Container(
    //       color: Colors.black,
    //       height: 1,
    //       width: MediaQuery.of(context).size.width * .4,
    //     ),
    //   ],
    // ),
    //               SizedBox(height: 20),
    //               //google sign button
    //               InkWell(
    //                 onTap: () {
    //                   googleLogin();
    //                 },
    //                 child: Container(
    //                   padding: EdgeInsets.only(
    //                       left: 0, top: 10, bottom: 10, right: 0),
    //                   // width: 250,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(5),
    //                     border: Border.all(),
    //                     color: Colors.white,
    //                   ),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Image.network(
    //                         "https://kgo.googleusercontent.com/profile_vrt_raw_bytes_1587515358_10512.png",
    //                         height: 30,
    //                         width: 30,
    //                       ),
    //                       SizedBox(width: 10),
    //                       Text(
    //                         "Sign in with Google",
    //                         style: TextStyle(
    //                           fontSize: 20,
    //                         ),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
