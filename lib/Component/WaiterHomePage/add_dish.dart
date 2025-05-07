import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../View/main_scaffold.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddDish extends StatelessWidget {
  const AddDish({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      content: ItemSelectionView(),
    );
  }
}

class ItemSelectionView extends StatelessWidget {
  const ItemSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ItemSelectionController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12.0.h),
                child: Text(
                  'add items',
                  style: TextStyle(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextField(
                controller: controller.searchController,
                onChanged: (value) => controller.filterItems(value),
                decoration: InputDecoration(
                  hintText: 'search by name / code',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.r),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 9.w, vertical: 12.h),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 30.h,
                child: Obx(() => ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildFilterChip('filter', controller,
                            isFilterIcon: true,
                            isSelected:
                                controller.selectedCategory.value == 'filter'),
                        SizedBox(width: 6.w),
                        _buildFilterChip('favorites', controller,
                            isSelected: controller.selectedCategory.value ==
                                'favorites'),
                        SizedBox(width: 6.w),
                        _buildFilterChip('indian', controller,
                            isSelected:
                                controller.selectedCategory.value == 'indian'),
                        SizedBox(width: 6.w),
                        _buildFilterChip('Liquor', controller,
                            isSelected:
                                controller.selectedCategory.value == 'Liquor'),
                        SizedBox(width: 6.w),
                        _buildFilterChip('Beverages', controller,
                            isSelected: controller.selectedCategory.value ==
                                'Beverages'),
                      ],
                    )),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: Obx(() => GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.2,
                        crossAxisSpacing: 7.5.w,
                        mainAxisSpacing: 7.5.h,
                      ),
                      itemCount: controller.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = controller.filteredItems[index];
                        return _buildDishItem(item, controller);
                      },
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => controller.addToList(),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: Text(
                          'add to list',
                          style:
                              TextStyle(color: Colors.black, fontSize: 12.sp),
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => controller.proceedNext(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        child: Text(
                          'Add',
                          style:
                              TextStyle(color: Colors.white, fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, ItemSelectionController controller,
      {bool isSelected = false, bool isFilterIcon = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () => controller.selectCategory(label),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 12.sp,
                ),
              ),
              if (isFilterIcon) ...[
                SizedBox(width: 3.w),
                Icon(
                  Icons.filter_list,
                  size: 12.sp,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDishItem(MenuItem item, ItemSelectionController controller) {
    return Obx(() {
      final bool isSelected = item.quantity.value > 0;
      final Color backgroundColor =
          isSelected ? Colors.green.shade300 : Colors.grey.shade300;

      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6.r),
          border: isSelected
              ? Border.all(color: Colors.blue.shade700, width: 1.5.w)
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 11.sp),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    '₹${item.price.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 9.sp, color: Colors.black54),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6.r),
                      bottomRight: Radius.circular(6.r),
                    ),
                  ),
                  child: Text(
                    '${item.quantity.value}x',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => controller.toggleItemSelection(item.id),
                borderRadius: BorderRadius.circular(6.r),
                child: const SizedBox.expand(),
              ),
            ),
            if (isSelected)
              Positioned(
                bottom: 6.h,
                right: 6.w,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => controller.decreaseQuantity(item.id),
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3.r),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Icon(Icons.remove, size: 10.sp),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.w),
                      child: Text(
                        '${item.quantity.value}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => controller.increaseQuantity(item.id),
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(3.r),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Icon(Icons.add, size: 10.sp),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../Component/HomePage/add_customer.dart';

class MenuItem {
  final int id;
  final String name;
  final double price;
  final String category;
  RxInt quantity = 0.obs;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    int initialQuantity = 0,
  }) {
    quantity.value = initialQuantity;
  }
}

class ItemSelectionController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  RxString selectedCategory = 'favorites'.obs;
  RxList<MenuItem> allItems = <MenuItem>[].obs;
  RxList<MenuItem> filteredItems = <MenuItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadItems();
    filterByCategory(selectedCategory.value);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _loadItems() {
    // Sample menu items - in a real app, these would come from an API or database
    allItems.addAll([
      MenuItem(id: 1, name: 'Dish no. 1', price: 250, category: 'indian'),
      MenuItem(id: 2, name: 'Dish no. 2', price: 300, category: 'favorites'),
      MenuItem(id: 3, name: 'Dish no. 3', price: 350, category: 'indian'),
      MenuItem(id: 4, name: 'Dish no. 4', price: 250, category: 'Liquor'),
      MenuItem(id: 5, name: 'Dish no. 5', price: 300, category: 'Beverages'),
      MenuItem(id: 6, name: 'Dish no. 6', price: 350, category: 'favorites'),
    ]);
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      // If search is empty, filter by selected category
      filterByCategory(selectedCategory.value);
    } else {
      // Filter by search query
      filteredItems.value = allItems
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  void filterByCategory(String category) {
    if (category == 'filter') {
      filteredItems.value = allItems;
    } else {
      filteredItems.value = allItems
          .where(
              (item) => item.category.toLowerCase() == category.toLowerCase())
          .toList();
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    if (category == 'filter') {
      // Show filter options dialog
      showFilterDialog();
    } else {
      // Filter items by category
      filterByCategory(category);
    }
  }

  void showFilterDialog() {
    // Show a filter dialog - this would be implemented based on your needs
    Get.dialog(AlertDialog(
      title: const Text('Filter Options'),
      content: const Text('Filter options would be shown here'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
      ],
    ));
  }

  void toggleItemSelection(int itemId) {
    final index = allItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (allItems[index].quantity.value == 0) {
        // If not selected, add one item
        allItems[index].quantity.value = 1;
      } else {
        // If already selected, show controls but don't change quantity
        // Controls are always visible for selected items
      }
    }
  }

  void increaseQuantity(int itemId) {
    final index = allItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      allItems[index].quantity.value++;
    }
  }

  void decreaseQuantity(int itemId) {
    final index = allItems.indexWhere((item) => item.id == itemId);
    if (index != -1 && allItems[index].quantity.value > 0) {
      allItems[index].quantity.value--;
    }
  }

  List<MenuItem> getSelectedItems() {
    return allItems.where((item) => item.quantity.value > 0).toList();
  }

  void addToList() {
    final selectedItems = getSelectedItems();
    if (selectedItems.isEmpty) {
      Get.snackbar(
        'No Items Selected',
        'Please select at least one item',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Return to order form with selected items
    Get.back(result: selectedItems);
  }

  void proceedNext() {
    addToList(); // Same functionality for this example
  }
}
