import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String myText;
  final Color myColor;
  final String? routeName;
  final VoidCallback? onPressed;

  const SmallButton({
    required this.myText,
    required this.myColor,
    this.routeName,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed ??
            () {
              Navigator.pushNamed(context, routeName!);
            },
        child: Container(
          decoration: BoxDecoration(
            color: myColor,
            borderRadius: BorderRadius.circular(800),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                myText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
