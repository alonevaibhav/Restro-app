import 'package:get/get.dart';
import '../../view/auth/auth_page.dart';
import '../../view/homepage/home_page.dart';
import '../Component/WaiterHomePage/add_customer.dart';
import '../Component/WaiterHomePage/add_dish.dart';
import '../Component/WaiterHomePage/view_order.dart';
import '../View/ChefPanel/chef_home.dart';
import 'app_bindings.dart';

class AppRoutes {
  // Route names
  static const login = '/login';
  static const waiter = '/waiter';
  static const chef = '/chef';
  static const homepage = '/homepage';
  static const notification = '/notification';
  static const history = '/history';
  static const settings = '/settings';
  static const addCustomer = '/addCustomer';
  static const addDish = '/addDish';
  static const readyOrder = '/add_dish';

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
      name: addCustomer,
      page: () => const AddCustomer(),
      binding: AppBindings(),
    ),
    GetPage(
      name: addDish,
      page: () => const AddDish(),
      binding: AppBindings(),
    ),
    GetPage(
      name: readyOrder,
      page: () => const ReadyOrder(),
      binding: AppBindings(),
    ),
    GetPage(
      name: waiter,
      page: () => const HomePage(),
      binding: AppBindings(),
    ),
    GetPage(
      name: chef,
      page: () => const ChefHome(),
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
