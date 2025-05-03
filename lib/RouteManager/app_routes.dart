import 'package:get/get.dart';
import '../../view/auth/auth_page.dart';
import '../../view/homepage/home_page.dart';
import '../Component/HomePage/add_customer.dart';
import '../Component/HomePage/add_dish.dart';
import 'app_bindings.dart';

class AppRoutes {
  // Route names
  static const login     = '/login';
  static const homepage  = '/homepage';
  static const notification = '/notification';
  static const history   = '/history';
  static const settings  = '/settings';
  static const addcustomer  = '/addcustomer';
  static const add_dish  = '/add_dish';

  // All of your pages
  static final routes = <GetPage>[
    GetPage(
      name: login,
      page: () => const LoginView(),
      binding: AppBindings(),
    ),
    GetPage(
      name: homepage,
      page: () => const HomePage(),
      binding: AppBindings(),
    ),
    GetPage(
      name: addcustomer,
      page: () => const AddCustomer(),
      binding: AppBindings(),
    ),
    GetPage(
      name: add_dish,
      page: () => const AddDish(),
      binding: AppBindings(),
    ),
    GetPage(
      name: notification,
      page: () => const LoginView(),
    ),
    GetPage(
      name: history,
      page: () => const LoginView(),
    ),
    GetPage(
      name: settings,
      page: () => const LoginView(),
    ),
  ];
}
