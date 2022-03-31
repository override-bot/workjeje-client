import 'package:flutter/material.dart';

class OptionBox extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Function() onPressed;
  OptionBox(
      {required this.icon,
      required this.label,
      required this.onPressed,
      required this.color});
  @override
  OptionBoxState createState() => OptionBoxState();
}

class OptionBoxState extends State<OptionBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 100,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: widget.color),
        child: Column(
          children: [
            Container(child: Icon(widget.icon, color: Colors.white)),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
