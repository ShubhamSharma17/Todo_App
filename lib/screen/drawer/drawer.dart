// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/screen/addList/add_list_screen.dart';
import 'package:todo_app/screen/authentication/login/login_screen.dart';
import 'package:uuid/uuid.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  File? profilePic;
  String? profilePicShow;
  String userUniqueId = FirebaseAuth.instance.currentUser!.uid;
  String? userName;

//function for store image
  storeAndShowPicture() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    //get User name
    String providerId = FirebaseAuth
        .instance.currentUser!.providerData[0].providerId
        .toString();
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("profilePic $userUniqueId")
        .doc("profilePic")
        .get();
    //if user login with google
    if (providerId == "google.com") {
      userName = FirebaseAuth.instance.currentUser!.displayName.toString();
    }
    //if user login without google
    else {
      userName = documentSnapshot.get("name").toString();
    }

    //get User email
    String useremail = FirebaseAuth.instance.currentUser!.email.toString();

    log("user name $userName");
    log("user email $useremail");

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
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      log("Image selected!");
      log(userUniqueId.toString());
      log(downloadUrl.toString());

      FirebaseFirestore.instance
          .collection("profilePic $userUniqueId")
          .doc("profilePic")
          .set({
        "profilePic": downloadUrl,
        "name": userName,
        "gmail": useremail
      });
    } else {
      log("no image selected!");
    }
  }

  //function for get profilePic from firestore-database
  getImage() async {
    // log("provider id ${FirebaseAuth.instance.currentUser!.providerData[0].providerId}");
    // log("method call and show pic path $profilePicShow");
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("profilePic $userUniqueId")
        .doc("profilePic")
        .get();
    // log("get user name from firebase.... ${documentSnapshot.get("name").toString()}");
    // log(documentSnapshot.get("profilePic").toString());
    setState(() {
      profilePicShow = documentSnapshot.get("profilePic").toString();
    });
    // log(profilePicShow.toString());
  }

  //function for logout
  logOut() async {
    String providerId =
        FirebaseAuth.instance.currentUser!.providerData[0].providerId;
    //when user login with google
    if (providerId == "google.com") {
      await GoogleSignIn().disconnect();
      FirebaseAuth.instance.signOut();
      log("Sign Out from google");
      // Navigator.popUntil(context, (route) => route.isFirst);
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => LoginScreen(),
      //     ));
    }
    //when user login with gmail
    else {
      FirebaseAuth.instance.signOut();
      log("Sign Out from without google");
    }
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));

    log("Log out Successfully.........)");
  }

  @override
  void initState() {
    setState(() {
      getImage();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .7,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("profilePic $userUniqueId")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Container(
                      height: MediaQuery.of(context).size.height * .2,
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> userMap =
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                          return Column(
                            children: [
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () async {
                                  storeAndShowPicture();
                                },
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.grey,
                                  backgroundImage:
                                      NetworkImage(userMap["profilePic"]),
                                ),
                              ),
                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userMap["name"],
                                    // "name",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(height: 5),
                                  Text(userMap["gmail"]),
                                ],
                              )
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    return Text("No Data!");
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
            },
            child: ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home_filled, size: 30),
            ),
          ),
          ListTile(
            title: Text("Profile"),
            leading: Icon(Icons.person_sharp, size: 30),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddListScreen(),
                  ));
            },
            child: ListTile(
              title: Text("Add todo list"),
              leading: Icon(Icons.view_list_sharp, size: 30),
            ),
          ),
          Divider(
            thickness: 1,
            color: Colors.black,
          ),
          ListTile(
            title: Text("Setting"),
            leading: Icon(Icons.settings, size: 30),
          ),
          InkWell(
            onTap: () {
              //logout method
              // FirebaseAuth.instance.signOut();
              // Navigator.popUntil(context, (route) => route.isFirst);
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => LoginScreen(),
              //     ));
              logOut();
            },
            child: ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout_sharp, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
