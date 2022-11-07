// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddListScreen extends StatefulWidget {
  const AddListScreen({super.key});

  @override
  State<AddListScreen> createState() => _AddListScreenState();
}

class _AddListScreenState extends State<AddListScreen> {
  TextEditingController taskController = TextEditingController();
  final userUniqueId = FirebaseAuth.instance.currentUser!.uid;

  //function for add list
  void addTask() {
    String addTask = taskController.text.trim();
    taskController.clear();

    if (addTask != "") {
      try {
        FirebaseFirestore.instance
            .collection(userUniqueId)
            .add({"task": addTask.toUpperCase()});
        log("Task add successfully!");
      } on FirebaseException catch (e) {
        log(e.code.toString());
      }
    }
    // if (addTask != "") {
    //   try {
    //     FirebaseFirestore.instance
    //         .collection("taskList")
    //         .add({"task": addTask.toUpperCase()});
    //     log("Task add successfully!");
    //   } on FirebaseException catch (e) {
    //     log(e.code.toString());
    //   }
    // }
    else {
      log("Correct data!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add List")),
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(labelText: "Add Task"),
                ),
                SizedBox(height: 15),
                CupertinoButton(
                  color: Colors.blue,
                  child: Text("Add"),
                  onPressed: () {
                    addTask();
                  },
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
