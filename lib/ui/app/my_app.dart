import 'package:co_sport_map/ui/auth/auth_widget.dart';
import 'package:co_sport_map/ui/register/register_widget.dart';
import 'package:co_sport_map/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Co sport',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.appBarBackgroundColor,
            elevation: 0,
            titleTextStyle: TextStyle(
                color: AppColors.titleTextStyle,
                fontSize: 22,
                fontWeight: FontWeight.w500)),
        backgroundColor: AppColors.backgroundColor,
      ),
      routes: {
        '/auth': (context) => const AuthWidget(),
        '/auth/registration': (context) => const RegisterWidget(),
      },
      initialRoute: '/auth',
    );
  }
}
