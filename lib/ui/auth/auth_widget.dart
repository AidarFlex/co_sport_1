import 'dart:developer';

import 'package:co_sport_map/ui/theme/app_colors.dart';
import 'package:co_sport_map/ui/theme/app_text_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Co Sport'),
      ),
      body: const SingleChildScrollView(child: _HeaderAuthWidget()),
    );
  }
}

class _HeaderAuthWidget extends StatelessWidget {
  const _HeaderAuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Добро пожаловать!', style: AppTextStyle.largeTextStyle),
            SizedBox(height: 10),
            Text('Вход', style: AppTextStyle.largeTextStyle),
            SizedBox(height: 20),
            _FormAuthWidget(),
          ],
        ),
      ),
    );
  }
}

class _FormAuthWidget extends StatelessWidget {
  const _FormAuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const InputDecoration emailFieldDecorator = InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        isCollapsed: true,
        fillColor: Colors.red,
        focusColor: Colors.red,
        hoverColor: Colors.red,
        labelText: 'Email');

    const InputDecoration passwordFieldDecorator = InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        isCollapsed: true,
        fillColor: Colors.red,
        focusColor: Colors.red,
        hoverColor: Colors.red,
        labelText: 'Password');
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        const TextField(decoration: emailFieldDecorator),
        const SizedBox(height: 10),
        const TextField(decoration: passwordFieldDecorator),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.bottomRight,
          child: RichText(
            text: TextSpan(
                text: 'Забыли пароль?',
                style: const TextStyle(color: AppColors.buttonTextStyle),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => log('Забыли пароль?')),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Войти'),
              style: const ButtonStyle(),
            )),
        const SizedBox(height: 30),
        const Text('Еще не зарегистрированы?'),
        const SizedBox(height: 5),
        RichText(
          text: TextSpan(
              text: 'Регистрация',
              style: const TextStyle(color: AppColors.buttonTextStyle),
              recognizer: TapGestureRecognizer()
                ..onTap = () =>
                    Navigator.of(context).pushNamed('/auth/registration')),
        ),
      ],
    );
  }
}
