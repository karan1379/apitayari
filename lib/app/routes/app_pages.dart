import 'package:get/get.dart';

import '../modules/home/home_screen.dart';
import '../modules/login_module/login_screen.dart';

class AppRoutes{

  static const login = "/login";
  static const home = "/home";


}

class AppPages{

  static const initial = AppRoutes.home;

  static final routes = [

    GetPage(name: AppRoutes.login, page:() =>LoginScreen()),
    GetPage(name: AppRoutes.home, page:() => HomeScreen(),)

  ];

}