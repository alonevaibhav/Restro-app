import 'dart:async';
import 'package:get/get.dart';

class OrderTimerController extends GetxController {
  final Map<int, RxInt> _tableTimers = {}; // tableNumber -> minutes
  final Map<int, Timer> _timers = {};      // tableNumber -> Timer instance

  /// Start timer for a specific table
  void startTimer(int tableNumber) {
    // Cancel any existing timer
    stopTimer(tableNumber);

    _tableTimers[tableNumber] = 0.obs;

    _timers[tableNumber] = Timer.periodic(const Duration(minutes: 1), (_) {
      _tableTimers[tableNumber]?.value++;
    });
  }

  /// Stop timer for a specific table (optional for now)
  void stopTimer(int tableNumber) {
    _timers[tableNumber]?.cancel();
    _timers.remove(tableNumber);
    _tableTimers.remove(tableNumber);
  }

  /// Get current timer value for a table (e.g., "2M")
  RxString getFormattedTime(int tableNumber) {
    if (!_tableTimers.containsKey(tableNumber)) {
      return '0M'.obs;
    }

    final RxInt timer = _tableTimers[tableNumber]!;

    // Create a derived RxString that updates when RxInt changes
    final RxString formattedTime = '${timer.value}M'.obs;

    ever(timer, (val) {
      formattedTime.value = '${val}M';
    });

    return formattedTime;
  }



  @override
  void onClose() {
    _timers.forEach((_, timer) => timer.cancel());
    super.onClose();
  }
}
