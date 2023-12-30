import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/helper/color.dart';
import 'package:todo_app/helper/ui_helper.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/models/user_model.dart';

class TODOScreen extends StatefulWidget {
  final UserModel user;
  final User firebaseUser;

  const TODOScreen({
    super.key,
    required this.user,
    required this.firebaseUser,
  });

  @override
  State<TODOScreen> createState() => _TODOScreenState();
}

class _TODOScreenState extends State<TODOScreen> {
  TextEditingController taskController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // method for upload notes in firebase
  void uploadNotes(String notes, String description) {
    String tempNoteID = uuid.v1();
    String tempNote = notes;
    String tempDescription = description;
    if (tempNote != "" && tempDescription != "") {
      NotesModel notesModel = NotesModel(
        notes: tempNote,
        description: tempDescription,
        noteID: tempNoteID,
        date: DateTime.now(),
      );

      FirebaseFirestore.instance
          .collection("notes")
          .doc(widget.firebaseUser.uid)
          .collection("allNotes")
          .doc(tempNoteID)
          .set(notesModel.toMap());
      log("Notes uploded successfully....");

      //now updating note id
      widget.user.noteID = tempNoteID;
      FirebaseFirestore.instance
          .collection("user")
          .doc(widget.user.uid!)
          .set(widget.user.toMap());
      log("Note id  updated successfully....");
      taskController.clear();
      descriptionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: purpleCF9FFF,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // for task text feild
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Enter Notes',
                      hintText: "Enter Your Notes here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                verticalSpacesLarge,
                // for description text feild
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Enter Description',
                      hintText: "Enter Your Descreption here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    maxLines: null,
                  ),
                ),
                verticalSpacesLarge,
                CupertinoButton(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  color: Colors.green,
                  child: const Text(
                    "Upload Task",
                    style: TextStyle(
                      color: black,
                      fontWeight: FontWeight.w500,
                      fontSize: 21,
                    ),
                  ),
                  onPressed: () {
                    uploadNotes(
                      taskController.text.trim().toString(),
                      descriptionController.text.trim().toString(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
