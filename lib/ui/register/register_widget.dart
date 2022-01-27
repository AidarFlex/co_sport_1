import 'package:co_sport_map/controllers/auth_contoller.dart';
import 'package:co_sport_map/ui/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Co Sport'),
      ),
      body: const SingleChildScrollView(child: HeaderWidget()),
    );
  }
}

final emailController = TextEditingController();
final passwordController = TextEditingController();

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

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
            FormRegisterWidget(),
          ],
        ),
      ),
    );
  }
}

class FormRegisterWidget extends StatelessWidget {
  const FormRegisterWidget({Key? key}) : super(key: key);

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

    // const InputDecoration userNameFieldDecorator = InputDecoration(
    //     border: OutlineInputBorder(),
    //     contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //     isCollapsed: true,
    //     fillColor: Colors.red,
    //     focusColor: Colors.red,
    //     hoverColor: Colors.red,
    //     labelText: 'UserName');

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
        // const _ErrorMessageWidget(),
        // const SizedBox(height: 10),
        TextField(controller: emailController, decoration: emailFieldDecorator),
        const SizedBox(height: 10),
        // TextField(
        //     controller: model?.userNameController,
        //     decoration: userNameFieldDecorator),
        // const SizedBox(height: 10),
        TextField(
            controller: passwordController,
            decoration: passwordFieldDecorator,
            obscureText: true),
        const SizedBox(height: 20),
        const RegistretionButtonWidget(),
        const SizedBox(height: 10),
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

class RegistretionButtonWidget extends StatelessWidget {
  const RegistretionButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          AuthController.authInstance.register(
              emailController.text.trim(), passwordController.text.trim());
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
          ),
        ),
        child: const Text('Registration!'),
      ),
    );
  }
}

// class _ErrorMessageWidget extends StatelessWidget {
//   const _ErrorMessageWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final errorMessage = RegisterProvider.watch(context)?.model.errorMessage;
//     if (errorMessage == null) return const SizedBox.shrink();

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Text(
//         errorMessage,
//         style: const TextStyle(
//           fontSize: 17,
//           color: Colors.red,
//         ),
//       ),
//     );
//   }
// }
