import 'package:flutter/material.dart';

class PopUp {
  void showError(message, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
                height: 120,
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(children: [
                  Icon(
                    Icons.dangerous,
                    color: Colors.red,
                    size: 35,
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ])),
          );
        });
  }

  void showSuccess(message, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
                height: 120,
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(children: [
                  Icon(
                    Icons.check,
                    color: Colors.blue,
                    size: 35,
                  ),
                  Container(
                    height: 10,
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ])),
          );
        });
  }
}
