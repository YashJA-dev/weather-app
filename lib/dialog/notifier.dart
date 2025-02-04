import 'package:flutter/material.dart';

class Notifier {
  BuildContext context;
  Notifier(this.context);
  void showSnackBar({required String message, int? sec}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: sec ?? 3), // Adjust duration as needed
        // action: SnackBarAction(
        //   label: message,
        //   onPressed: () {},
        // ),
      ),
    );
  }
}
