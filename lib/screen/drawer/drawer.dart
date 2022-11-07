// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/home.dart';
import 'package:todo_app/screen/addList/add_list_screen.dart';
import 'package:todo_app/screen/authentication/login/login_with_gmail.dart';
import 'package:uuid/uuid.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  File? profilePic;
  String userUniqueId = FirebaseAuth.instance.currentUser!.uid;
  String? profilePicShow;

  storeAndShowPicture() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

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
      log(downloadUrl.toString());

      FirebaseFirestore.instance
          .collection(userUniqueId)
          .doc("profilePic")
          .set({"profilePic": downloadUrl});
    } else {
      log("no image selected!");
    }
  }

  // void initialValue() async {
  //   DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection(userUniqueId)
  //       .doc("profilePic")
  //       .get();
  //   setState(() {
  //     // Map<String, dynamic> userData = snapshot.data();
  //     profilePicShow = snapshot.data().toString();
  //     log("-----profilepicshow$profilePicShow");
  //   });
  // }

  @override
  // void initState() {
  //   // TODO: implement initState
  //   initialValue();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .7,
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Container(
            padding: EdgeInsets.only(top: 40),
            width: MediaQuery.of(context).size.width * .65,
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          profilePic != null ? FileImage(profilePic!) : null,
                    ),
                  ),
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shubham Sharma",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      Text("shubhamsharma706568@gmail.com"),
                    ],
                  )
                ],
              ),
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
              FirebaseAuth.instance.signOut();

              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ));
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
