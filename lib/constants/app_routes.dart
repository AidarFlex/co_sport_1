import 'package:co_sport_map/home/home_widget.dart';
import 'package:co_sport_map/ui/auth/auth_widget.dart';
import 'package:co_sport_map/ui/register/register_widget.dart';
import 'package:get/get.dart';

class AppRoutes {
  AppRoutes._();
  static final routes = [
    GetPage(name: '/', page: () => AuthWidget()),
    GetPage(name: '/register', page: () => RegisterWidget()),
    GetPage(name: '/home', page: () => HomeWidget()),
  ];
}
