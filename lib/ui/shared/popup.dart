import 'package:flutter/material.dart';

class PopUp {
  void showError(message, context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.red),
                  ))
            ],
            content: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dangerous,
                        color: Colors.red,
                        size: 25,
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.red[400],
                            fontSize: 15,
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
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
            content: SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.blue,
                        size: 25,
                      ),
                      Container(
                        height: 10,
                      ),
                      Text(
                        message,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      ),
                    ])),
          );
        });
  }

  Future popLoad(context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
              width: MediaQuery.of(context).size.width / 1.2,
              height: 100,
              child: Center(
                  child: CircularProgressIndicator(
                color: Color.fromARGB(255, 14, 140, 172),
              )),
            ),
          );
        });
  }
}
