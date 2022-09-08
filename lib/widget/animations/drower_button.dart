// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class DrawerButton extends StatelessWidget {
  final VoidCallback onpressed;
  final String label;
  final Widget icon;
  final bool? beta;

  const DrawerButton({
    Key? key,
    required this.onpressed,
    required this.label,
    required this.icon,
    this.beta,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(0))),
        ),
        child: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        onPressed: onpressed,
      ),
    );

    //  FlatButton.icon(
    //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
    //   onPressed: onpressed,
    //   shape: const RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(0),
    //           topRight: Radius.circular(20),
    //           bottomRight: Radius.circular(20),
    //           bottomLeft: Radius.circular(0))),
    //   label: Text(
    //     label,
    //     style: const TextStyle(color: Colors.white),
    //   ),
    //   icon: icon,
    //   textColor: Colors.white,
    //   color: Theme.of(context).primaryColor,
    // );
  }
}
