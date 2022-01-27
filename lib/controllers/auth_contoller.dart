import 'dart:developer';

import 'package:co_sport_map/constants/firebase_constatns.dart';
import 'package:co_sport_map/home/home_widget.dart';
import 'package:co_sport_map/ui/auth/auth_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController authInstance = Get.find();
  late Rx<User?> firebaseUser;

  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());

    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user != null) {
      Get.offAll(() => const HomeWidget());
    } else {
      Get.offAll(() => const AuthWidget());
    }
  }

  void register(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log(e.message!);
      Get.snackbar('Error', e.message!, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      log(e.toString());
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      log(e.message!);
    } catch (e) {
      log(e.toString());
    }
  }

  void singOut() {
    try {
      auth.signOut();
    } catch (e) {
      log(e.toString());
    }
  }
}
