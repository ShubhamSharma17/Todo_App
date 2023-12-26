import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/helper/color.dart';
import 'package:todo_app/helper/ui_helper.dart';
import 'package:todo_app/models/user_model.dart';

class TODOScreen extends StatefulWidget {
  final UserModel user;
  final User firebaseUser;

  const TODOScreen({super.key, required this.user, required this.firebaseUser});

  @override
  State<TODOScreen> createState() => _TODOScreenState();
}

class _TODOScreenState extends State<TODOScreen> {
  TextEditingController taskController = TextEditingController();
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
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                      labelText: 'Please search here ',
                      // contentPadding: EdgeInsets.all(50),
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 20),
                    maxLines: 5,
                    minLines: 2,
                  ),
                ),
                verticalSpacesLarge,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: gray939393,
                      child: const Text(
                        "Add Task",
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: const Color.fromARGB(255, 246, 143, 143),
                      child: const Text(
                        "Cancel Task",
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w500,
                          fontSize: 21,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
