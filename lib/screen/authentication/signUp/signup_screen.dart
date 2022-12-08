// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  File? profilePic;

//function for select image from device
  storeAndShowPicture() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      File convertedSelectedImage = File(selectedImage.path);
      setState(() {
        profilePic = convertedSelectedImage;
      });
      log(profilePic.toString());
    } else {
      log("no image selected!");
    }
  }

  //function for create new account
  void createAccount() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String name = nameController.text.trim();

    if (email == "" || password == "" || name == "" || profilePic == null) {
      log("Enter correct credencials ");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        if (userCredential.user != null) {
          log("User Created ");
          log("Calling user data function");
          storeUserData();
          // log(FirebaseAuth.instance.currentUser!.uid.toString());

          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        log(e.code.toString());
      }
    }
  }

  //function for store image,name and email in firebase-database and image in  firestore-database after user create
  storeUserData() async {
    String userUniqueId = FirebaseAuth.instance.currentUser!.uid.toString();
    //image store in firebase storage
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("profilePictures")
        .child(userUniqueId)
        .child(Uuid().v1())
        .putFile(profilePic!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    log("Image selected!");
    log(userUniqueId.toString());
    log(downloadUrl.toString());

    FirebaseFirestore.instance
        .collection("profilePic $userUniqueId")
        .doc("profilePic")
        .set({
      "profilePic": downloadUrl,
      "name": nameController.text.trim(),
      "gmail": emailController.text.trim()
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("SignUp Screen")),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Glad to see you!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              Divider(
                height: 10,
                color: Colors.black,
                thickness: 1,
              ),
              // SizedBox(height: 10),
              CupertinoButton(
                onPressed: () {
                  storeAndShowPicture();
                },
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      profilePic != null ? FileImage(profilePic!) : null,
                ),
              ),
              SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all()),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          labelText: 'Enter Your Name',
                        )),
                  )),
              SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all()),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          labelText: 'Enter Your Email',
                        )),
                  )),
              SizedBox(height: 10),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all()),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          labelText: 'Enter password',
                        )),
                  )),
              SizedBox(height: 20),
              CupertinoButton(
                  padding: EdgeInsets.symmetric(horizontal: 90),
                  color: Colors.black,
                  child: Text("Create Account"),
                  onPressed: () {
                    createAccount();
                    // Timer(
                    //   Duration(seconds: 7),
                    //   () {
                    //     storeUserData();
                    //   },
                    // );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
