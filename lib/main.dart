import 'package:co_sport_map/constants/firebase_constatns.dart';
import 'package:co_sport_map/controllers/auth_contoller.dart';
import 'package:co_sport_map/ui/app/my_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebaseInitialization.then((value) => Get.put(AuthController()));
  const app = MyApp();
  runApp(app);
}
