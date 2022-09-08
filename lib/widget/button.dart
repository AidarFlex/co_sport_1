import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String myText;
  final Color myColor;
  final String? routeName;
  final VoidCallback? onPressed;

  const Button({
    required this.myText,
    required this.myColor,
    this.routeName,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.myColor,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        ),
        child: Text(
          widget.myText,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        onPressed: widget.onPressed ??
            () => Navigator.pushNamed(context, widget.routeName!),
      ),
    );
  }
}
