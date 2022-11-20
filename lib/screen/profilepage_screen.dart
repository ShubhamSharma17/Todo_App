// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({super.key});

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  String userUniqueId = FirebaseAuth.instance.currentUser!.uid;
  File? profilePic;
  String downloadUrl = "";
  TextEditingController nameController = TextEditingController();

  //function for store image
  selectPicture() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    //get User name
    // String providerId = FirebaseAuth
    //     .instance.currentUser!.providerData[0].providerId
    //     .toString();
    // DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
    //     .collection("profilePic $userUniqueId")
    //     .doc("profilePic")
    //     .get();
    //if user login with google
    // if (providerId == "google.com") {
    //   userName = FirebaseAuth.instance.currentUser!.displayName.toString();
    // }
    // //if user login without google
    // else {
    //   userName = documentSnapshot.get("name").toString();
    // }

    //get User email
    // String useremail = FirebaseAuth.instance.currentUser!.email.toString();

    // log("user name $userName");
    // log("user email $useremail");

    if (selectedImage != null) {
      File convertedSelectedImage = File(selectedImage.path);
      setState(() {
        profilePic = convertedSelectedImage;
      });
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("profilePictures")
          .child(userUniqueId)
          .child(Uuid().v1())
          .putFile(profilePic!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String tempDownloadUrl = await taskSnapshot.ref.getDownloadURL();
      setState(() {
        downloadUrl = tempDownloadUrl;
      });
      log("Image selected!");
      log(userUniqueId.toString());
      log(downloadUrl.toString());
    } else {
      log("no image selected!");
    }
  }

  //Save user data function
  saveData() async {
    String name = nameController.text.trim();

    if (downloadUrl != "" && name != "") {
      FirebaseFirestore.instance
          .collection("profilePic $userUniqueId")
          .doc("profilePic")
          .update({
        "profilePic": downloadUrl,
        "name": name,
        // "gmail": useremail
      });
    } else if (downloadUrl != "") {
      FirebaseFirestore.instance
          .collection("profilePic $userUniqueId")
          .doc("profilePic")
          .update({
        "profilePic": downloadUrl,
        // "name": name,
        // "gmail": useremail
      });
    } else if (name != "") {
      FirebaseFirestore.instance
          .collection("profilePic $userUniqueId")
          .doc("profilePic")
          .update({
        // "profilePic": downloadUrl,
        "name": name,
        // "gmail": useremail
      });
    }
    log("User data saved!.... :)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile page Screen")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 50, right: 50, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("profilePic $userUniqueId")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Expanded(
                        // height: MediaQuery.of(context).size.height * .5,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userDataMap =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return Column(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: downloadUrl != ""
                                      ? NetworkImage(downloadUrl)
                                      : NetworkImage(userDataMap["profilePic"]),
                                ),
                                CupertinoButton(
                                    onPressed: () {
                                      selectPicture();
                                    },
                                    child: Container(
                                      // color: Colors.amber,
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Text(
                                        "Change profile photo",
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    )),
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: userDataMap["name"],
                                    // label: Text(
                                    //   userDataMap["name"],
                                    //   style: TextStyle(fontSize: 20),
                                    // ),
                                  ),
                                ),
                                // Text(
                                //   userDataMap["name"],
                                //   // "name",
                                //   style: TextStyle(fontSize: 20),
                                // ),
                                SizedBox(height: 15),
                                CupertinoButton(
                                  color: Colors.amber,
                                  child: Text("Save"),
                                  onPressed: () {
                                    saveData();
                                  },
                                )
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return Text("Sorry there is no data!");
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
              //   CircleAvatar(
              //     radius: 50,
              //   ),
              //   Text("Name Change here!"),
            ],
          ),
        ),
      ),
    );
  }
}
