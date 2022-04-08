import 'package:flutter/material.dart';

class PopUp {
  void showError(message, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              width: MediaQuery.of(context).size.width / 1.1,
              child: Text(
                message,
                style: TextStyle(
                    color: Colors.red[400],
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        });
  }

  void showSuccess(message, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              width: MediaQuery.of(context).size.width / 1.1,
              child: Text(
                message,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
          );
        });
  }
}
