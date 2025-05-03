class TableData {
  final int number;
  String? customerName;
  double? price;
  String? time;
  bool isAvailable;

  TableData({
    required this.number,
    this.customerName,
    this.price,
    this.time,
    this.isAvailable = true,
  });
}
