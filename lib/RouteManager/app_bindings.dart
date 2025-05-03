import 'package:get/get.dart';

import '../Controller/login_controller.dart';
import '../Controller/sidebar_controller.dart';
import '../Controller/table_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register all controllers here
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SidebarController>(() => SidebarController(), fenix: true);
    Get.lazyPut<TableController>(() => TableController(), fenix: true);
  //   Get.lazyPut<FirstPageController>(() => FirstPageController());
  //   Get.lazyPut<SecondPageController>(() => SecondPageController());
  //   Get.lazyPut<ThirdPageController>(() => ThirdPageController());
  }
}
