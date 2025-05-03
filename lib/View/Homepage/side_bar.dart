//
// // FILE: lib/app/widgets/hotel_sidebar.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../Controller/sidebar_controller.dart';
//
// class HotelSidebar extends StatelessWidget {
//   final SidebarController controller;
//
//   const HotelSidebar({
//     Key? key,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       final isExpanded = controller.isExpanded.value;
//
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         width: isExpanded ? 210 : 0,
//         height: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 4,
//               offset: const Offset(2, 0),
//             ),
//           ],
//         ),
//         child: isExpanded
//             ? SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               _buildSidebarItem(
//                 icon: Icons.restaurant_outlined,
//                 title: "RESTRAUNT",
//                 index: 0,
//               ),
//               const SizedBox(height: 16),
//               _buildSidebarItem(
//                 icon: Icons.coffee_outlined,
//                 title: "NOTIFICATION",
//                 index: 1,
//               ),
//               const SizedBox(height: 16),
//               _buildSidebarItem(
//                 icon: Icons.history_outlined,
//                 title: "HISTORY",
//                 index: 2,
//               ),
//               const SizedBox(height: 16),
//               _buildSidebarItem(
//                 icon: Icons.settings_outlined,
//                 title: "SETTINGS",
//                 index: 3,
//               ),
//             ],
//           ),
//         )
//             : const SizedBox(),
//       );
//     });
//   }
//
//   Widget _buildSidebarItem({
//     required IconData icon,
//     required String title,
//     required int index,
//   }) {
//     return Obx(() {
//       final isSelected = controller.selectedIndex.value == index;
//
//       return Container(
//         height: 40,
//         width: double.infinity,
//         margin: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? const Color(0xFF4169E8) : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(8),
//             onTap: () => controller.changeSelectedIndex(index),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 children: [
//                   Icon(
//                     icon,
//                     color: isSelected ? Colors.white : Colors.black,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/sidebar_controller.dart';
import '../../RouteManager/app_routes.dart';

class HotelSidebar extends StatelessWidget {
  final double width;
  HotelSidebar({Key? key, required this.width}) : super(key: key);
  final controller = Get.find<SidebarController>();

  final List<_MenuItem> items = const [
    _MenuItem(icon: Icons.restaurant_outlined, title: 'Restaurant', activeIcon: Icons.restaurant),
    _MenuItem(icon: Icons.notifications_outlined, title: 'Notification', activeIcon: Icons.notifications),
    _MenuItem(icon: Icons.history_outlined, title: 'History', activeIcon: Icons.history),
    _MenuItem(icon: Icons.settings_outlined, title: 'Settings', activeIcon: Icons.settings),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Hotel logo or brand
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.hotel,
                  size: 32,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 12),
                const Text(
                  'LUXURY',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 16),
          // Menu items
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, index) => _buildSidebarItem(index, items[index]),
            ),
          ),
          // Bottom section
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Material(
              borderRadius: BorderRadius.circular(30),
              color: Colors.blue.shade50,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.help_outline, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Help & Support',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(int index, _MenuItem item) {
    return Obx(() {
      final selected = controller.selectedIndex.value == index;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              controller.changeSelectedIndex(index);
              controller.toggleSidebar();

              // navigate based on index
              switch (index) {
                case 0: Get.toNamed(AppRoutes.homepage);       break;
                case 1: Get.toNamed(AppRoutes.notification);   break;
                case 2: Get.toNamed(AppRoutes.history);        break;
                case 3: Get.toNamed(AppRoutes.settings);       break;
              }
            },

            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.blue.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected
                      ? Colors.blue.shade700
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      selected ? item.activeIcon : item.icon,
                      key: ValueKey(selected),
                      color: selected ? Colors.blue.shade700 : Colors.black54,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: selected ? Colors.blue.shade700 : Colors.black87,
                        fontSize: 16,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  if (selected)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade700,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _MenuItem {
  final IconData icon;
  final IconData activeIcon;
  final String title;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.activeIcon,
  });
}