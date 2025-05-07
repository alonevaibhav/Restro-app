import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Controller/chef_controller.dart';

class ChefPage extends StatelessWidget {
  const ChefPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChefController controller = Get.put(ChefController());

    return Scaffold(
      body: Column(
        children: [
          // Tab buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.5.w, vertical: 7.5.h),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() => _buildTabButton(
                        'accept orders',
                        controller.selectedTab.value == 'accept',
                        () => controller.changeTab('accept'),
                      )),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Obx(() => _buildTabButton(
                        'done orders',
                        controller.selectedTab.value == 'done',
                        () => controller.changeTab('done'),
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
                  : controller.selectedTab.value == 'accept'
                      ? _buildNewOrdersView(controller)
                      : _buildDoneOrdersView(controller),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 9.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(4.5.r),
          border: Border.all(color: Colors.blue),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue,
            fontWeight: FontWeight.w500,
            fontSize: 10.5.sp,
          ),
        ),
      ),
    );
  }

  // View for "accept orders" tab
  Widget _buildNewOrdersView(ChefController controller) {
    final pendingOrders = controller.orders
        .where(
            (order) => !order.isAccepted && !order.isRejected && !order.isDone)
        .toList();
    return pendingOrders.isEmpty
        ? const Center(child: Text('No new orders to accept'))
        : ListView.builder(
            itemCount: pendingOrders.length,
            padding: EdgeInsets.all(7.5.w),
            itemBuilder: (context, index) {
              final order = pendingOrders[index];
              return _buildOrderCard(
                order: order,
                controller: controller,
                isNewOrder: true,
              );
            },
          );
  }

  // View for "done orders" tab
  Widget _buildDoneOrdersView(ChefController controller) {
    final acceptedOrders = controller.orders
        .where((order) => order.isAccepted && !order.isDone)
        .toList();

    return acceptedOrders.isEmpty
        ? const Center(child: Text('No orders in preparation'))
        : ListView.builder(
            itemCount: acceptedOrders.length,
            padding: EdgeInsets.all(7.5.w),
            itemBuilder: (context, index) {
              final order = acceptedOrders[index];
              return _buildOrderCard(
                order: order,
                controller: controller,
                isNewOrder: false,
              );
            },
          );
  }

  Widget _buildOrderCard({
    required OrderData order,
    required ChefController controller,
    required bool isNewOrder,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 9.h),
      elevation: 1.5,
      child: Padding(
        padding: EdgeInsets.all(9.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order no. ${order.orderNumber}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      order.time,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 7.5.w),
                    Text(
                      'table no: ${order.tableNumber}',
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 4.5.h),
            Text(
              'please enter your details',
              style: TextStyle(
                fontSize: 10.5.sp,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 9.h),

            // Food items with quantity
            Container(
              padding: EdgeInsets.all(7.5.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.foodItems,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                      ),
                    ),
                  ),
                  Container(
                    width: 18.w,
                    height: 18.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: Text(
                      '${order.quantity}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 9.h),
            // Customer name field
            Container(
              padding: EdgeInsets.all(7.5.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.customerName.isEmpty
                          ? 'Enter full name'
                          : order.customerName,
                      style: TextStyle(
                        fontSize: 10.5.sp,
                        color: order.customerName.isEmpty
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: 18.w,
                    height: 18.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 9.h),
            // Customization field
            Container(
              padding: EdgeInsets.all(7.5.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                order.customization.isEmpty
                    ? 'Enter full name'
                    : order.customization,
                style: TextStyle(
                  fontSize: 10.5.sp,
                  color:
                      order.customization.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Action buttons
            isNewOrder
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showRejectDialog(
                              Get.context!, order, controller),
                          icon: const Icon(Icons.close, color: Colors.red),
                          label: Text(
                            'Reject',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.r),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 7.5.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              controller.acceptOrder(order.orderNumber),
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: Text(
                            'Accept',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 10.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Optional: your action for "Preparing"
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.black, width: 1),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            'Preparing',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Your action for "Mark as Done"
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            'Mark as Done',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(
      BuildContext context, OrderData order, ChefController controller) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.r),
          ),
          child: Container(
            padding: EdgeInsets.all(12.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Reason For Cancelling The Order',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  'Please Enable Location Permission For Better Recommendations Of Products',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 9.h),
                TextField(
                  controller: reasonController,
                  decoration: InputDecoration(
                    hintText: 'explain your reason',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.rejectOrder(
                          order.orderNumber, reasonController.text);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 10.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                    child: Text(
                      'cancel order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
