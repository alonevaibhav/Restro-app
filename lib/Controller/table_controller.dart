

import 'package:get/get.dart';
import '../RouteManager/app_routes.dart';

class TableData {
  final int number;
  double price;
  String time;
  bool isAvailable;
  String customerName;

  TableData({
    required this.number,
    required this.price,
    required this.time,
    required this.isAvailable,
    this.customerName = '',
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

    // Simulate fetching tables from API
    Future.delayed(const Duration(milliseconds: 500), () {
      // Generate some tables with random availability
      tables.value = List.generate(
        12,
            (index) => TableData(
          number: index + 1,
          price: index % 2 == 0 ? 3500 : 0, // Alternate between 3500 and 0
          time: 'time-10',
          isAvailable: index % 2 == 0 ? false : true, // Alternate availability
        ),
      );

      isLoading.value = false;
    });
  }

  void changeTab(String tab) {
    selectedTab.value = tab;
    fetchTables();
  }

  void selectTable(int tableNumber) {
    // Find the selected table
    final selectedTable = tables.firstWhere((table) => table.number == tableNumber);

    // If table is available (empty), navigate to add customer screen
    if (selectedTable.isAvailable) {
      Get.toNamed(
          AppRoutes.addcustomer,
          arguments: {'tableNumber': tableNumber}
      );
    } else {
      // If table is occupied, navigate to view the existing order
      // Get.toNamed(AppRoutes.viewOrder, arguments: {'tableNumber': tableNumber});
    }
  }

  // Update a table's status after an order is placed
  void updateTableStatus(int tableNumber, String customerName, double orderAmount) {
    final index = tables.indexWhere((table) => table.number == tableNumber);
    if (index != -1) {
      tables[index].isAvailable = false;
      tables[index].customerName = customerName;
      tables[index].price = orderAmount;
      tables[index].time = 'time-${DateTime.now().hour}';
      tables.refresh(); // Important: refresh the list to update UI
    }
  }
}
