import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/helper/color.dart';
import 'package:todo_app/helper/ui_helper.dart';
import 'package:todo_app/models/note_model.dart';
import 'package:todo_app/models/user_model.dart';

class CheckTodoTaskScreen extends StatefulWidget {
  final UserModel user;
  final User firebaseUser;
  final NotesModel notes;

  const CheckTodoTaskScreen({
    super.key,
    required this.user,
    required this.firebaseUser,
    required this.notes,
  });

  @override
  State<CheckTodoTaskScreen> createState() => _CheckTodoTaskScreenState();
}

class _CheckTodoTaskScreenState extends State<CheckTodoTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: purpleCF9FFF,
          title: Text(
            "Created on ${widget.notes.date!.toString().substring(0, 9)}",
          ),
          titleTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: black,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: purpleCF9FFF,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.notes.notes.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 25,
                      color: black,
                    ),
                  ),
                ),
                verticalSpaceMedium,
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: purpleCF9FFF,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.notes.description.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 21,
                      color: black,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
