import 'package:flutter/material.dart';
import 'package:todo_app/helper/ui_helper.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          verticalSpacesLarge,
          Text(title),
        ],
      ),
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return loadingDialog;
      },
    );
  }

  static void showAlertDialog(
      BuildContext context, String title, String content) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return alertDialog;
      },
    );
  }
}
