import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Controller/table_controller.dart';

class ReadyOrder extends StatelessWidget {
  const ReadyOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final TableController controller = Get.find<TableController>();
    final arguments = Get.arguments as Map<String, dynamic>;
    final int tableNumber = arguments['tableNumber'] as int;
    final bool isReady = arguments['isReady'] as bool? ?? false;

    // Find the table data
    final TableData order = controller.tables.firstWhere(
          (table) => table.number == tableNumber,
      orElse: () => TableData(
        number: tableNumber,
        price: 0,
        time: 'time-00',
        isAvailable: true,
      ),
    );

    return Transform.scale(
      // scale: 0.75, // Reduce entire screen by 25%
      alignment: Alignment.topLeft,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderCard(
                order: order,
                controller: controller,
                isReady: isReady,
              ),
            ],
          ),
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
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order no. 1',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      order.time,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'table no: ${order.number}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'Please enter your details',
              style: TextStyle(
                fontSize: 50.sp,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter full name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                suffixIcon: Container(
                  width: 30.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(4.r),
                      bottomRight: Radius.circular(4.r),
                    ),
                  ),
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              decoration: InputDecoration(
                hintText: 'Customization',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
            ),
            SizedBox(height: 16.h),
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
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                    side: isReady ? BorderSide.none : BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Text(
                  isReady ? 'Orders ready' : 'Preparing order',
                  style: TextStyle(
                    color: isReady ? Colors.white : Colors.black,
                    fontSize: 16.sp,
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
