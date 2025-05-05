
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Controller/table_controller.dart';
import '../../RouteManager/app_routes.dart';

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    final TableController controller = Get.put(TableController());

    return Column(
      children: [
        // Tab buttons
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                child: Obx(() => _buildTabButton(
                  'take orders',
                  controller.selectedTab.value == 'take',
                      () => controller.changeTab('take'),
                )),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Obx(() => _buildTabButton(
                  'ready orders',
                  controller.selectedTab.value == 'ready', () => controller.changeTab('ready'),
                )),
              ),
            ],
          ),
        ),

        // Tables area
        Expanded(
          child: Obx(
                () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAreaSection('Common area', controller),
                  // SizedBox(height: 20.h),
                  // _buildAreaSection('Common area', controller),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: Colors.blue),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildAreaSection(String areaName, TableController controller) {
    return Container(
      color: const Color(0xFFFFFCBD), // Light yellow background
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.w, bottom: 10.h),
            child: Text(
              areaName,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
            ),
            itemCount: controller.tables.length,
            itemBuilder: (context, index) {
              final table = controller.tables[index];
              return _buildTableCard(
                tableNumber: table.number,
                price: table.price,
                time: table.time,
                isAvailable: table.isAvailable,
                controller: controller,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableCard({
    required int tableNumber,
    required double price,
    required String time,
    required bool isAvailable,
    required TableController controller,
  }) {
    return InkWell(
      onTap: () => controller.selectTable(tableNumber),
      child: Container(
        decoration: BoxDecoration(
          color: isAvailable ? Colors.green : Colors.red.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tableNumber.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              isAvailable ? '₹ 00' : '₹ ${price.toInt()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
