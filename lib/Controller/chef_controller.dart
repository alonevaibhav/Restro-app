import 'package:get/get.dart';

class OrderData {
  final int orderNumber;
  final int tableNumber;
  final String time;
  final String customerName;
  final String foodItems;
  final int quantity;
  final String customization;
  bool isAccepted;
  bool isRejected;
  bool isDone;
  String rejectionReason;

  OrderData({
    required this.orderNumber,
    required this.tableNumber,
    required this.time,
    required this.customerName,
    required this.foodItems,
    required this.quantity,
    this.customization = '',
    this.isAccepted = false,
    this.isRejected = false,
    this.isDone = false,
    this.rejectionReason = '',
  });
}

class ChefController extends GetxController {
  RxString selectedTab = 'accept'.obs;
  RxBool isLoading = false.obs;
  RxList<OrderData> orders = <OrderData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() {
    isLoading.value = true;

    // Simulate fetching orders from API
    Future.delayed(const Duration(milliseconds: 500), () {
      // Generate mock orders for testing the UI
      orders.value = List.generate(
        5,
            (index) => OrderData(
          orderNumber: index + 1,
          tableNumber: (index % 2 == 0) ? 7 : 6,
          time: 'time-${10 + index}',
          customerName: index % 3 == 0 ? 'Customer ${index + 1}' : '',
          foodItems: 'food items', // This would be replaced with actual items
          quantity: 1 + index % 3,
          customization: index % 2 == 0 ? 'No onions, extra cheese' : '',
          isAccepted: index > 2, // First 3 orders are new, the rest are accepted
          isRejected: false,
          isDone: false,
        ),
      );

      isLoading.value = false;
    });
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    // Refresh data when changing tabs
    fetchOrders();
  }

  // Accept a new order from the waiter
  void acceptOrder(int orderNumber) {
    final index = orders.indexWhere((order) => order.orderNumber == orderNumber);
    if (index != -1) {
      orders[index].isAccepted = true;
      orders.refresh();

      // Show a snackbar to confirm the action
      Get.snackbar(
        'Order Accepted',
        'Order #$orderNumber has been accepted and is now in preparation',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Reject an order with a reason
  void rejectOrder(int orderNumber, String reason) {
    final index = orders.indexWhere((order) => order.orderNumber == orderNumber);
    if (index != -1) {
      orders[index].isRejected = true;
      orders[index].rejectionReason = reason;
      orders.refresh();

      // Show a snackbar to confirm the action
      Get.snackbar(
        'Order Rejected',
        'Order #$orderNumber has been rejected',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Mark an order as done (finished cooking)
  void markOrderAsDone(int orderNumber) {
    final index = orders.indexWhere((order) => order.orderNumber == orderNumber);
    if (index != -1) {
      orders[index].isDone = true;
      orders.refresh();

      // Notify that the order is ready for pickup
      Get.snackbar(
        'Order Ready',
        'Order #$orderNumber is ready for pickup',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get order details by order number
  OrderData? getOrderDetails(int orderNumber) {
    try {
      return orders.firstWhere((order) => order.orderNumber == orderNumber);
    } catch (e) {
      return null;
    }
  }
}