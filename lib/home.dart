// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'screen/addList/add_list_screen.dart';
import 'screen/authentication/login/login_with_gmail.dart';
import 'screen/drawer/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool checkValue = false;

class _HomeScreenState extends State<HomeScreen> {
  final userUniqueId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Todo List"),
          FloatingActionButton(
            heroTag: null,
            elevation: 0,
            child: Icon(Icons.logout),
            //log out method
            onPressed: () async {
              log("Current user.....${FirebaseAuth.instance.currentUser}");
              log("provider id ${FirebaseAuth.instance.currentUser!.providerData[0].providerId}");
              String providerId =
                  FirebaseAuth.instance.currentUser!.providerData[0].providerId;
              //when user login with google
              if (providerId == "google.com") {
                await GoogleSignIn().disconnect();
                FirebaseAuth.instance.signOut();
                log("Sign Out from google");
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              }
              //when user login with gmail
              else {
                FirebaseAuth.instance.signOut();
                log("Sign Out from without google");
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              }
            },
          ),
        ]),
      ),
      drawer: DrawerScreen(),
      body: Stack(
        children: [
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.all(15),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(userUniqueId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> userData =
                            snapshot.data!.docs[index].data();
                        return Column(
                          children: [
                            ListTile(
                                tileColor: Colors.grey[200],
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${index + 1}"),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .5,
                                        child: Text("${userData["task"]}")),
                                    FloatingActionButton(
                                        heroTag: null,
                                        elevation: 0,
                                        backgroundColor: Colors.transparent,
                                        mini: true,
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection(userUniqueId)
                                              .doc(snapshot.data!.docs[index].id
                                                  .toString())
                                              .delete();
                                          log("Delete Successfull");
                                        },
                                        child: Icon(
                                          Icons.delete_outlined,
                                          color: Colors.black,
                                        )),
                                  ],
                                )),
                            SizedBox(height: 10),
                          ],
                        );
                      },
                    );
                  } else {
                    return Image(
                      // image:
                      //     AssetImage("assets/image/undraw_Empty_re_opql.png"),
                      // fit: BoxFit.fill,
                      image: NetworkImage(
                          "https://assets.materialup.com/uploads/8b0ec3cb-a32d-40bb-b17d-66b9fd744172/attachment.jpg"),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(
                right: 15,
                bottom: 10,
              ),
              child: FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AddListScreen(),
                      ));
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
