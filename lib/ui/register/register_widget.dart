import 'package:co_sport_map/ui/register/register_model.dart';
import 'package:co_sport_map/ui/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Co Sport'),
      ),
      body: const SingleChildScrollView(child: _HeaderWidget()),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Регистрация', style: AppTextStyle.largeTextStyle),
            SizedBox(height: 20),
            _FormRegisterWidget(),
          ],
        ),
      ),
    );
  }
}

class _FormRegisterWidget extends StatelessWidget {
  const _FormRegisterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = RegisterProvider.read(context)?.model;
    const InputDecoration emailFieldDecorator = InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        isCollapsed: true,
        fillColor: Colors.red,
        focusColor: Colors.red,
        hoverColor: Colors.red,
        labelText: 'Email');

    const InputDecoration userNameFieldDecorator = InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        isCollapsed: true,
        fillColor: Colors.red,
        focusColor: Colors.red,
        hoverColor: Colors.red,
        labelText: 'UserName');

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
        const _ErrorMessageWidget(),
        const SizedBox(height: 10),
        TextField(
            controller: model?.emailController,
            decoration: emailFieldDecorator),
        const SizedBox(height: 10),
        TextField(
            controller: model?.userNameController,
            decoration: userNameFieldDecorator),
        const SizedBox(height: 10),
        TextField(
            controller: model?.passwordTextController,
            decoration: passwordFieldDecorator,
            obscureText: true),
        const SizedBox(height: 20),
        const _RegistretionButtonWidget(),
        SizedBox(height: 10),
        SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Назад'),
              style: const ButtonStyle(),
            )),
      ],
    );
  }
}

class _RegistretionButtonWidget extends StatelessWidget {
  const _RegistretionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = RegisterProvider.watch(context)?.model;
    final onPressed = model?.canStartRegistratoin == true
        ? () => model?.registration(context)
        : null;
    final child = model?.isRegistretionProgress == true
        ? const SizedBox(
            width: 15,
            height: 15,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Text('Login');
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        // style: ButtonStyle(
        //   backgroundColor: MaterialStateProperty.all(Colors.blue),
        //   foregroundColor: MaterialStateProperty.all(Colors.white),
        //   textStyle: MaterialStateProperty.all(
        //     const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        //   ),
        //   padding: MaterialStateProperty.all(
        //     const EdgeInsets.symmetric(
        //       horizontal: 15,
        //       vertical: 8,
        //     ),
        //   ),
        // ),
        child: child,
      ),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = RegisterProvider.watch(context)?.model.errorMessage;
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        errorMessage,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.red,
        ),
      ),
    );
  }
}
