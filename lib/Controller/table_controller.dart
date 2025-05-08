
import 'package:get/get.dart';
import '../Component/WaiterHomePage/add_customer.dart';
import '../RouteManager/app_routes.dart';

class TableData {
  final int number;
  double price;
  String time;
  bool isAvailable;
  String customerName;
  bool isReady;
  bool isServed;
  bool isUrgent; // <-- New field
  List<OrderItem> orderItems; // This needs to store order items

  TableData({
    required this.number,
    required this.price,
    required this.time,
    required this.isAvailable,
    this.customerName = '',
    this.isReady = false,
    this.isServed = false,
    this.isUrgent = false, // <-- Initialize it
    this.orderItems = const [], // Initialize with an empty list
  });
}


class TableController extends GetxController {
  RxString selectedTab = 'take'.obs;
  RxBool isLoading = false.obs;
  RxList<TableData> tables = <TableData>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTables();
  }

  void fetchTables() {
    isLoading.value = true;

    // Simulate fetching tables from API based on selected tab
    Future.delayed(const Duration(milliseconds: 500), () {
      if (selectedTab.value == 'take') {
        // Generate tables for "take orders" tab
        tables.value = List.generate(
          12,
              (index) => TableData(
            number: index + 1,
            price: 0, // Initially, all tables have price 0
            time: 'time-10',
            isAvailable: true, // Initially, all tables are available
            isReady: false,
          ),
        );
      } else {
        // For "ready orders" tab, we'll show the same data but filtered in the UI
        // This simulates an API that would return only ready orders
        tables.value = List.generate(
          6,
              (index) => TableData(
            number: index + 1,
            price: 3500 + (index * 100),
            time: 'time-${10 + index}',
            isAvailable: false,
            customerName: 'Customer ${index + 1}',
            isReady: true,
            isServed: false,


              ),
        );
      }

      isLoading.value = false;
    });
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    fetchTables();
  }

  void updateTableUrgentStatus(int tableNumber, bool isUrgent) {
    final index = tables.indexWhere((table) => table.number == tableNumber);
    if (index != -1) {
      tables[index].isUrgent = isUrgent;
      tables.refresh(); // Refresh the list to update UI
    }
  }


  void selectTable(int tableNumber) {
    // Find the selected table
    final selectedTable = tables.firstWhere((table) => table.number == tableNumber);

    // Log selected table info for debugging
    print('Selecting table $tableNumber, isAvailable: ${selectedTable.isAvailable}');
    if (!selectedTable.isAvailable) {
      print('Order items count: ${selectedTable.orderItems.length}');
    }

    // If table is available (empty), navigate to add customer screen
    if (selectedTable.isAvailable) {
      Get.toNamed(
          AppRoutes.addCustomer,
          arguments: {'tableNumber': tableNumber}
      );
    } else {
      // If table is occupied, navigate to view/edit the existing order
      Get.toNamed(
          AppRoutes.addCustomer,
          arguments: {
            'tableNumber': tableNumber,
            'customerName': selectedTable.customerName,
            'orderAmount': selectedTable.price,
            'existingOrderItems': selectedTable.orderItems, // Pass existing order items

          }
      );
    }
  }

  // Updated method to handle both table status and order items update
  void updateTableWithOrderItems(int tableNumber, String customerName, double orderAmount, List<OrderItem> items) {
    final index = tables.indexWhere((table) => table.number == tableNumber);
    if (index != -1) {
      tables[index].isAvailable = false;
      tables[index].customerName = customerName;
      tables[index].price = orderAmount;
      tables[index].time = 'time-${DateTime.now().hour}';
      tables[index].isReady = false;

      // Save order items to the table
      tables[index].orderItems = List<OrderItem>.from(items);

      tables.refresh(); // Important: refresh the list to update UI

      // Log for debugging
      print('Updated table $tableNumber with ${items.length} items');
    }
  }

  // Keep this simple method for backward compatibility
  void updateTableStatus(int tableNumber, String customerName, double orderAmount) {
    updateTableWithOrderItems(tableNumber, customerName, orderAmount, []);
  }

  // Mark an order as ready
  void markOrderAsReady(int tableNumber) {
    final index = tables.indexWhere((table) => table.number == tableNumber);
    if (index != -1) {
      tables[index].isReady = true;
      tables.refresh();

      // Navigate back to tables view if we're in order details
      Get.back();
    }
  }

  // Mark an order as served (completed)
  void markOrderAsServed(int tableNumber) {
    final index = tables.indexWhere((table) => table.number == tableNumber);
    if (index != -1) {
      tables[index].isServed = true;

      // Optionally, we could reset the table to available status
      // tables[index].isAvailable = true;
      // tables[index].customerName = '';
      // tables[index].price = 0;
      // tables[index].isReady = false;

      tables.refresh();

      // Navigate back to ready orders list
      Get.back();
    }
  }
}