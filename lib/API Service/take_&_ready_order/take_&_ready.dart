import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for your API - replace with your actual API base URL
  final String baseUrl = 'https://your-api-base-url.com/api';

  // Headers for API requests
  Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Add any auth headers if needed
    // 'Authorization': 'Bearer $token',
  };

  // Get all tables data
  Future<Map<String, dynamic>> getTables() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tables'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load tables: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tables: $e');
    }
  }

  // Get pending orders
  Future<List<dynamic>> getPendingOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/pending'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load pending orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching pending orders: $e');
    }
  }

  // Get ready orders
  Future<List<dynamic>> getReadyOrders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/orders/ready'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load ready orders: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ready orders: $e');
    }
  }

  // Submit new order
  Future<Map<String, dynamic>> submitOrder({
    required int tableNumber,
    required String customerName,
    required String customization,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: headers,
        body: json.encode({
          'tableNumber': tableNumber,
          'customerName': customerName,
          'customization': customization,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to submit order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error submitting order: $e');
    }
  }

  // Mark order as ready
  Future<Map<String, dynamic>> markOrderReady(int orderId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/ready'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to mark order as ready: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }

  // Mark order as preparing
  Future<Map<String, dynamic>> markOrderPreparing(int orderId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/orders/$orderId/preparing'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to mark order as preparing: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }
}