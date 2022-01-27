import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RegisterModel extends ChangeNotifier {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isRegistretionProgress = false;
  bool get canStartRegistratoin => !_isRegistretionProgress;
  bool get isRegistretionProgress => _isRegistretionProgress;

  Future<void> registration(BuildContext context) async {
    FirebaseAuth regitrationUser = FirebaseAuth.instance;
    final userName = userNameController.text;
    final email = emailController.text;
    final password = passwordTextController.text;

    if (email.isEmpty || password.isEmpty || userName.isEmpty) {
      _errorMessage = 'Все поля долны быть заполнены';
      notifyListeners();
      return;
    }
    _errorMessage = null;
    _isRegistretionProgress = true;
    notifyListeners();

    try {
      final UserCredential userCredential = await regitrationUser
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "userID": userCredential.user!.uid,
        "userName": userName,
        "email": email,
      });
      userCredential.user!.updateDisplayName(userName);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _errorMessage = 'The account already exists for that email.';
      }
    } catch (error) {
      _errorMessage = 'An error has occurred...';
    }
    _isRegistretionProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }
  }
}

class RegisterProvider extends InheritedNotifier {
  final RegisterModel model;

  const RegisterProvider({
    Key? key,
    required this.model,
    required Widget child,
  }) : super(
          key: key,
          notifier: model,
          child: child,
        );

  static RegisterProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RegisterProvider>();
  }

  static RegisterProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<RegisterProvider>()
        ?.widget;
    return widget is RegisterProvider ? widget : null;
  }
}
