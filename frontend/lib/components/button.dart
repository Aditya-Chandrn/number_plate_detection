import 'package:flutter/material.dart';
import 'package:number_plate_detection/utils/constants.dart';

class Button extends StatefulWidget {
  final String name;
  final Function() action;
  const Button({super.key, required this.name, required this.action});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.action,
      style: ElevatedButton.styleFrom(
        backgroundColor: Constants.theme,
        foregroundColor: Colors.white,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(widget.name, style: TextStyle(fontSize: 20)),
    );
  }
}
