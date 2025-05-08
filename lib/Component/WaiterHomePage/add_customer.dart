import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/table_controller.dart';
import '../../Controller/timer_controller.dart';
import '../../View/main_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../RouteManager/app_routes.dart';
import 'add_dish.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({super.key});

  @override
  Widget build(BuildContext context) {

    final int tableNumber = Get.arguments['tableNumber'];
    final String? customerName = Get.arguments['customerName'];
    final double? orderAmount = Get.arguments['orderAmount'];
    final List<OrderItem>? existingOrderItems = Get.arguments['existingOrderItems'];

    return MainScaffold(
      content: OrderDetailView(
        tableNumber: tableNumber,
        customerName: customerName,
        orderAmount: orderAmount,
        existingOrderItems: existingOrderItems, // FIX 2: Pass it to OrderDetailView
      ),
    );
  }
}


class OrderDetailView extends StatelessWidget {
  final int tableNumber;
  final String? customerName;
  final double? orderAmount;
  final List<OrderItem>? existingOrderItems;

  const OrderDetailView({
    Key? key,
    required this.tableNumber,
    this.customerName,
    this.orderAmount,
    this.existingOrderItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OrderController controller = Get.put(OrderController(tableNumber));

    // Load the urgent state from the TableData
    final TableController tableController = Get.find<TableController>();
    final tableData = tableController.tables.firstWhere((table) => table.number == tableNumber);
    controller.isUrgent.value = tableData.isUrgent;

    // FIX 3: Log existing order items for debugging
    if (existingOrderItems != null) {
      print('Existing order items: ${existingOrderItems!.length}');
    } else {
      print('No existing order items');
    }

    // If existingOrderItems are provided, add them to the controller
    if (existingOrderItems != null && existingOrderItems!.isNotEmpty) {
      controller.orderItems.addAll(existingOrderItems!);
      controller.calculateTotal();
    }

    // If customerName and orderAmount are not null, populate the fields
    if (customerName != null) {
      controller.nameController.text = customerName!;
    }
    if (orderAmount != null) {
      controller.totalAmount.value = orderAmount!;
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(11.2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recipient name :',
                  style: TextStyle(
                      fontSize: 11.2.sp,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  'Table no :- $tableNumber',
                  style:
                  TextStyle(fontSize: 15.2.sp, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8.4.h),
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                hintText: 'Enter full name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.6.r),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.4.w, vertical: 11.2.h),
              ),
            ),
            SizedBox(height: 8.4.h),
            TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.6.r),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 8.4.w, vertical: 11.2.h),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items :',
                  style:
                  TextStyle(fontSize: 11.2.sp, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    Obx(() => OutlinedButton(
                      onPressed: () => controller.toggleUrgent(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: controller.isUrgent.value ? Colors.red : Colors.grey),
                        backgroundColor: controller.isUrgent.value ? Colors.red.withOpacity(0.1) : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        controller.isUrgent.value ? 'Urgent' : 'Mark as Urgent',
                        style: TextStyle(
                          color: controller.isUrgent.value ? Colors.red : Colors.black,
                          fontSize: 9.8.sp,
                        ),
                      ),
                    )),


                    SizedBox(width: 5.6.w),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.addDish)?.then((selectedItems) {
                          if (selectedItems != null) {
                            controller.addItemsFromSelection(selectedItems);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text('add items',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.8.sp)),
                          SizedBox(width: 2.8.w),
                          Icon(Icons.add,
                              color: Colors.white, size: 12.6.sp),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.4.h),
            Expanded(
              child: Obx(() => controller.orderItems.isEmpty
                  ? Center(
                child: Text(
                  'No items added yet',
                  style: TextStyle(color: Colors.grey, fontSize: 9.8.sp),
                ),
              )
                  : ListView.builder(
                itemCount: controller.orderItems.length,
                itemBuilder: (context, index) {
                  final item = controller.orderItems[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dish Name
                          Text(
                            item.name,
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.h),

                          // Incremental/Decremental Controls
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () => controller.decreaseQuantity(index),
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3.r),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Icon(Icons.remove, size: 12.sp),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '${item.quantity}',
                                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 8.w),
                                  InkWell(
                                    onTap: () => controller.increaseQuantity(index),
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(3.r),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Icon(Icons.add, size: 12.sp),
                                    ),
                                  ),
                                ],
                              ),

                              // Price of Individual Dish
                              Text(
                                '₹${item.price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),

                          // Total Price for the Quantity Selected
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Total: ₹${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
            ),

            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 11.2.w, vertical: 8.4.h),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 11.2.w, vertical: 8.4.h),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5.6.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Final Checkout Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11.2.sp)),
                        Obx(() => Text(
                          '₹ ${controller.totalAmount.value.toStringAsFixed(2)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11.2.sp),
                        )),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.4.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => controller.processKot(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 11.2.h),
                            side: BorderSide(color: Colors.grey),
                          ),
                          child: Text('kot',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 9.8.sp)),
                        ),
                      ),
                      SizedBox(width: 5.6.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.processOrder(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                vertical: 11.2.h),
                          ),
                          child: Text('Add Order',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.8.sp)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:get/get.dart';
// import '../../Controller/table_controller.dart';

class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class OrderController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  RxBool isUrgent = false.obs;
  RxList<OrderItem> orderItems = <OrderItem>[].obs;
  RxDouble totalAmount = 0.0.obs;
  final int tableNumber;

  OrderController(this.tableNumber);

  @override
  void onInit() {
    super.onInit();
    calculateTotal();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void addItemsFromSelection(List<MenuItem> selectedItems) {
    if (selectedItems.isNotEmpty) {
      for (var menuItem in selectedItems) {
        if (menuItem.quantity.value > 0) {
          final existingIndex = orderItems.indexWhere((item) => item.name == menuItem.name);

          if (existingIndex != -1) {
            final existing = orderItems[existingIndex];
            orderItems[existingIndex] = OrderItem(
              name: existing.name,
              price: existing.price,
              quantity: existing.quantity + menuItem.quantity.value, // FIX 4: Add to existing quantity instead of replacing
            );
          } else {
            orderItems.add(OrderItem(
              name: menuItem.name,
              price: menuItem.price,
              quantity: menuItem.quantity.value,
            ));
          }
        }
      }
      calculateTotal();
    }
  }

  void increaseQuantity(int index) {
    if (index >= 0 && index < orderItems.length) {
      orderItems[index] = OrderItem(
        name: orderItems[index].name,
        price: orderItems[index].price,
        quantity: orderItems[index].quantity + 1,
      );
      calculateTotal();
    }
  }

  void decreaseQuantity(int index) {
    if (index >= 0 && index < orderItems.length && orderItems[index].quantity > 1) {
      orderItems[index] = OrderItem(
        name: orderItems[index].name,
        price: orderItems[index].price,
        quantity: orderItems[index].quantity - 1,
      );
      calculateTotal();
    }
  }


  void toggleUrgent() {
    isUrgent.value = !isUrgent.value;

    // Update the table data in the TableController
    final TableController tableController = Get.find<TableController>();
    tableController.updateTableUrgentStatus(tableNumber, isUrgent.value);
  }


  void calculateTotal() {
    totalAmount.value = orderItems.fold(
      0.0, (sum, item) => sum + (item.price * item.quantity),
    );
  }

  void processKot() {
    if (orderItems.isEmpty) {
      Get.snackbar(
        'Empty Order',
        'Please add at least one item to proceed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'KOT Generated',
      'Kitchen Order Ticket has been sent to the kitchen',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void processOrder() {
    if (orderItems.isEmpty) {
      Get.snackbar(
        'Empty Order',
        'Please add at least one item to proceed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final TableController tableController = Get.find<TableController>();

      // FIX 5: Update table with order items
      tableController.updateTableWithOrderItems(
          tableNumber,
          nameController.text,
          totalAmount.value,
          orderItems.toList() // Pass the current order items to be saved
      );

      Get.snackbar(
        'Order Processed',
        'Order for ${nameController.text} has been processed successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // ✅ Start timer only if no existing items (i.e., it's a NEW order)
      final OrderTimerController orderTimerController = Get.find<OrderTimerController>();
      if (Get.arguments['existingOrderItems'] == null) {
        orderTimerController.startTimer(tableNumber);
      }



      Get.offNamed(AppRoutes.homepage);


    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not process order: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}