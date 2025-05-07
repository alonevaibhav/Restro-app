
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Controller/table_controller.dart';
import '../../Controller/timer_controller.dart';

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
                  controller.selectedTab.value == 'ready',
                      () => controller.changeTab('ready'),
                )),
              ),
            ],
          ),
        ),

        // Content area based on selected tab
        Expanded(
          child: Obx(
                () => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.selectedTab.value == 'take'
                ? _buildTablesView(controller)
                : _buildReadyOrdersView(controller),
          ),
        ),
      ],
    );
  }

  // View for "take orders" tab with tables
  Widget _buildTablesView(TableController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAreaSection('Common area', controller),
        ],
      ),
    );
  }

  // View for "ready orders" tab
  Widget _buildReadyOrdersView(TableController controller) {
    // Get only tables with orders that are ready
    final readyOrders = controller.tables.where((table) => !table.isAvailable && table.isReady).toList();

    return readyOrders.isEmpty
        ? const Center(child: Text('No ready orders'))
        : ListView.separated(
      itemCount: readyOrders.length,
      padding: EdgeInsets.all(10.w),
      itemBuilder: (context, index) {
        final order = readyOrders[index];
        return _buildOrderCard(
          order: order,
          controller: controller,
          isReady: true,
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 10.h), // 👈 space between cards
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
    final OrderTimerController orderTimerController = Get.find<OrderTimerController>();

    return InkWell(
      onTap: () => controller.selectTable(tableNumber),
      child: Container(
        decoration: BoxDecoration(
          color: isAvailable ? Colors.green : Colors.red.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            // Table Number (top-left)
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                tableNumber.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Price (center)
            Center(
              child: Text(
                isAvailable ? '₹ 00' : '₹ ${price.toInt()}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Timer (bottom-right)
            Align(
              alignment: Alignment.bottomRight,
              child: Obx(() {
                final RxString formattedTime = orderTimerController.getFormattedTime(tableNumber);
                return Text(
                  'Time: ${formattedTime.value}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                );

              }),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildOrderCard({
    required TableData order,
    required TableController controller,
    required bool isReady,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h * 0.7),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w * 0.7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order no. 1',
                  style: TextStyle(
                    fontSize: 14.sp ,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'time',
                      style: TextStyle(
                        fontSize: 14.sp * 0.7,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 10.w * 0.7),
                    Text(
                      'table no: ${order.number}',
                      style: TextStyle(
                        fontSize: 14.sp * 0.7,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6.h * 0.7),
            Text(
              'please enter your details',
              style: TextStyle(
                fontSize: 14.sp * 0.7,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 12.h * 0.7),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter full name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.r * 0.7),
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w * 0.7, vertical: 12.h * 0.7),
                suffixIcon: Container(
                  width: 30.w * 0.7,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.r * 0.7),
                      bottomRight: Radius.circular(4.r * 0.7),
                    ),
                  ),
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp * 0.7,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h * 0.7),
            TextField(
              decoration: InputDecoration(
                hintText: 'customisation',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.r * 0.7),
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w * 0.7, vertical: 12.h * 0.7),
              ),
            ),
            SizedBox(height: 16.h * 0.7),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isReady) {
                    controller.markOrderAsServed(order.number);
                  } else {
                    controller.markOrderAsReady(order.number);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isReady ? Colors.blue : Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14.h * 0.7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r * 0.7),
                    side: isReady
                        ? BorderSide.none
                        : BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  isReady ? 'Orders ready' : 'Preparing order',
                  style: TextStyle(
                    color: isReady ? Colors.white : Colors.black,
                    fontSize: 16.sp * 0.7,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
