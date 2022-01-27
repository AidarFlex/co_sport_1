import 'package:flutter/material.dart';

class AppTextFieldStyle {
  static const InputDecoration textFieldDecorator = InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    isCollapsed: true,
    fillColor: Colors.red,
    focusColor: Colors.red,
    hoverColor: Colors.red,
  );
}
