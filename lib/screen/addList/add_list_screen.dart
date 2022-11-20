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
  String dateString = " ";
  String timeString = " ";

  //function for add list
  void addTask() {
    String addTask = taskController.text.trim();
    taskController.clear();

    if (addTask != "" && dateString != "" && timeString != "") {
      try {
        FirebaseFirestore.instance.collection(userUniqueId).add({
          "task": addTask.toUpperCase(),
          "time": timeString,
          "date": dateString
        });
        log("Task add successfully!");
      } on FirebaseException catch (e) {
        log(e.code.toString());
      }
    } else {
      log("Correct data!");
    }
  }

  //function for get date from user
  date() async {
    final DateTime? getDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year, DateTime.now().month),
      lastDate: DateTime(2035),
    );
    setState(() {
      dateString =
          "${getDate!.day.toString()}-${getDate.month.toString()}-${getDate.year.toString()}";
    });
    log("Cheaking date $dateString");
  }

  //function for get time from user
  time() async {
    final TimeOfDay? getTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    setState(() {
      timeString = getTime!.format(context).toString();
    });
    log("Cheaking time ${timeString.toString()}");
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
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          // color: Colors.amber,
                          width: MediaQuery.of(context).size.width * .5,
                          child: TextField(
                            decoration: InputDecoration(
                                label: Text(dateString), enabled: false),
                          ),
                        ),
                        CupertinoButton(
                          child: Text("Date"),
                          onPressed: () {
                            date();
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                            // color: Colors.amber,
                            width: MediaQuery.of(context).size.width * .5,
                            child: TextField(
                              decoration: InputDecoration(
                                  label: Text(timeString), enabled: false),
                            )),
                        CupertinoButton(
                          child: Text("time"),
                          onPressed: () {
                            time();
                          },
                        )
                      ],
                    ),
                  ],
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
