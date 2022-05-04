// import 'package:co_sport_map/utils/contansts.dart';
// import 'package:co_sport_map/utils/validations.dart';
// import 'package:co_sport_map/widget/button.dart';
// import 'package:co_sport_map/widget/dividing_or.dart';
// import 'package:co_sport_map/widget/input_box.dart';
// import 'package:flutter/material.dart';

// class SignUp extends StatefulWidget {
//   const SignUp({Key? key}) : super(key: key);

//   @override
//   _SignUpState createState() => _SignUpState();
// }

// class _SignUpState extends State<SignUp> {
//   bool loading = false;
//   bool validate = false;
//   GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
//   final GlobalKey<ScaffoldState> _scaffoldKey2 = GlobalKey<ScaffoldState>();
//   String email = '';
//   String fullName = '';
//   String password = '';

//   checkAll() async {
//     FormState? form = formKey2.currentState;
//     form!.save();
//     if (!form.validate()) {
//       validate = true;
//       setState(() {});
//       showInSnackBar('Please fix the errors in red before submitting.');
//     } else {
//       Constants.prefs!.setBool("loggedin", true);
//       print("going to " + "/home");
//       Navigator.pushReplacementNamed(context, '/home');
//     }
//   }

//   void showInSnackBar(String value) {
//     _scaffoldKey2.currentState?.removeCurrentSnackBar();
//     _scaffoldKey2.currentState?.showSnackBar(SnackBar(content: Text(value)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey2,
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             CreateAccHeading(),
//             Form(
//               key: formKey2,
//               autovalidateMode: AutovalidateMode.always,
//               child: Column(
//                 children: [
//                   InputBox(
//                     enabled: !loading,
//                     hintText: "Full name",
//                     icon: const Icon(Icons.contacts_outlined),
//                     validateFunction: Validations?.validateNonEmpty,
//                     textInputAction: TextInputAction.done,
//                     onSaved: (String? val) {
//                       fullName = val!;
//                     },
//                   ),
//                   // InputBox(
//                   //   hintText: "Username",
//                   //   icon: Icon(Icons.account_circle_outlined),
//                   // ),
//                   InputBox(
//                     enabled: !loading,
//                     hintText: "E-mail",
//                     icon: const Icon(Icons.mail_outline),
//                     textInputAction: TextInputAction.done,
//                     validateFunction: Validations?.validateEmail,
//                     submitAction: checkAll,
//                     textInputType: TextInputType.emailAddress,
//                     onSaved: (String? val) {
//                       email = val!;
//                     },
//                   ),
//                   InputBox(
//                     enabled: !loading,
//                     hintText: "Password",
//                     obscureText: true,
//                     helpertext: "use at least 8 charecters",
//                     sufIcon: IconButton(
//                       icon: const Icon(Icons.remove_red_eye),
//                       splashRadius: 1,
//                       onPressed: () {},
//                     ),
//                     icon: const Icon(Icons.lock_outline),
//                     textInputAction: TextInputAction.done,
//                     validateFunction: Validations?.validatePassword,
//                   ),
//                 ],
//               ),
//             ),
//             Button(
//               myText: "Sign Up For Co Sport",
//               myColor: Theme.of(context).accentColor,
//               onPressed: () => checkAll(),
//             ),
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 50.0),
//               child: Text(
//                 "By signing up for Co Sport you agree to our terms and conditions and privacy policy",
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const DividingOr(),
//             Button(
//               myText: "Login",
//               myColor: Theme.of(context).primaryColor,
//               routeName: "/login",
//             ),
//             const SizedBox(height: 20),
//             // GoogleOauth(),
//             // SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CreateAccHeading extends StatelessWidget {
//   const CreateAccHeading({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 20),
//       child: Center(
//         child: Text(
//           "Create Account",
//           style: TextStyle(
//             fontSize: 40,
//             fontWeight: FontWeight.w700,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//       ),
//     );
//   }
// }
