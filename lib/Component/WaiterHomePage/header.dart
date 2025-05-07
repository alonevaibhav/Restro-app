import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../Controller/login_controller.dart';
import '../../Controller/sidebar_controller.dart';
import '../../RouteManager/app_routes.dart';

class HotelHeader extends StatelessWidget {
  HotelHeader({super.key});
  final sidebarController = Get.find<SidebarController>();
  final LoginController loginController = Get.find<LoginController>();

  // Function to build hotel name and address from currentAddress
  Widget _buildLocationHeader(String address) {
    if (address.isEmpty) {
      return const Text(
        "Welcome!",
        style: TextStyle(
          fontSize: 22,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    List<String> addressParts = address.split(',');
    String hotelName = addressParts.isNotEmpty ? addressParts[0] : '';
    String restAddress =
    addressParts.length > 1 ? addressParts.sublist(1).join(', ') : '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hotelName,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          restAddress,
          style: TextStyle(
            fontSize: 8.sp,
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.menu,
              size: 40,
            ),
            onPressed: sidebarController.toggleSidebar,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() => _buildLocationHeader(loginController.currentAddress.value)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {

              Get.offAllNamed(AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
