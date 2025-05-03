import 'package:get/get.dart';

class SidebarController extends GetxController {
  final selectedIndex = 0.obs;
  final isExpanded = false.obs; // start collapsed

  void changeSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void toggleSidebar() {
    isExpanded.value = !isExpanded.value;
  }
}