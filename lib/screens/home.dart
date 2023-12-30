import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/helper/color.dart';
import 'package:todo_app/helper/ui_helper.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/models/user_model.dart';
import 'package:todo_app/screens/Auth/login.dart';
import 'package:todo_app/screens/notification/notification_services.dart';
import 'package:todo_app/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  final User firebaseUser;

  const HomeScreen({super.key, required this.user, required this.firebaseUser});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationScerviceClass notificationScerviceClass =
      NotificationScerviceClass();
  Timer? timer;

  @override
  void initState() {
    notificationScerviceClass.initialiseNotification();
    super.initState();
    // call function in an interval of time...
    // timer = Timer.periodic(const Duration(minutes: 1), (timer) {
    //   log("function call ho rha hai check kar rha hu.....");
    //   notificationScerviceClass.sendNotification(
    //       "Checking.....", "testing initialise....");
    // });
  }

  @override
  void dispose() {
    super.dispose();
    log("ab function call nhi hoga.....");
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: purpleCF9FFF,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) {
                    return const LoginScreen();
                  }));
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("notes")
                .doc(widget.user.uid)
                .collection("allNotes")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot noteSnapshot = snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: noteSnapshot.docs.length,
                    itemBuilder: (context, index) {
                      NotesModel notesModel = NotesModel.fromMap(
                          noteSnapshot.docs[index].data()
                              as Map<String, dynamic>);
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: purpleCF9FFF,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ListTile(
                              onTap: () {},
                              title: Text(
                                notesModel.notes.toString(),
                                style: const TextStyle(color: black),
                              ),
                              subtitle: Text(
                                notesModel.description.toString(),
                                style: const TextStyle(color: black),
                              ),
                              trailing: InkWell(
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection("notes")
                                      .doc(widget.user.uid)
                                      .collection("allNotes")
                                      .doc(notesModel.noteID)
                                      .delete();
                                  log("task successfully deleted");
                                },
                                child: Icon(Icons.delete),
                              ),
                            ),
                          ),
                          verticalSpaceMedium,
                        ],
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString(),
                      style: const TextStyle(color: black));
                } else {
                  return const Text("No Chat!", style: TextStyle(color: black));
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        floatingActionButton: IconButton(
          onPressed: () {
            // dispose();
            Navigator.push(context, CupertinoPageRoute(
              builder: (context) {
                return TODOScreen(
                  firebaseUser: widget.firebaseUser,
                  user: widget.user,
                );
              },
            ));
          },
          //   log("Pressed....");
          //   notificationScerviceClass.sendNotification(
          //       "Testing", "notification testing...");
          // },
          icon: const Icon(Icons.send),
        ),
      ),
    );
  }
}
