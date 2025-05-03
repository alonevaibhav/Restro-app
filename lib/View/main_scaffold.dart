// lib/view/homepage/main_scaffold.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/sidebar_controller.dart';
import '../../Component/HomePage/header.dart';
import 'Homepage/side_bar.dart';

class MainScaffold extends StatelessWidget {
  final Widget content;
  const MainScaffold({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebarController = Get.find<SidebarController>();

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Header + content
            Column(
              children: [
                HotelHeader(),
                Expanded(child: content),
              ],
            ),

            // Sidebar overlay
            Obx(() {
              return sidebarController.isExpanded.value
                  ? Positioned.fill(
                child: GestureDetector(
                  onTap: sidebarController.toggleSidebar,
                  child: Container(
                    color: Colors.black54,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: HotelSidebar(
                        width: MediaQuery.of(context).size.width * 0.75,
                      ),
                    ),
                  ),
                ),
              )
                  : const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}
