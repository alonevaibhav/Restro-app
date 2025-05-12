import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../RouteManager/app_routes.dart';

/// Simple User model with role
class UserModel {
  final String username;
  final String password;
  final String role; // 'waiter' or 'chef'

  UserModel({
    required this.username,
    required this.password,
    required this.role,
  });
}

/// Controller for login logic and location
class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final rememberMe = false.obs;
  final isPasswordVisible = false.obs;

  var currentAddress = ''.obs;

  /// In-memory user store; replace with real API/Firebase in production
  final List<UserModel> _users = [
    UserModel(username: 'waiter1', password: 'wpass123', role: 'waiter'),
    UserModel(username: 'chef1', password: 'cpass123', role: 'chef'),
  ];

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle "remember me" checkbox
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  /// Attempt to sign in; navigate based on role
  void signIn() {
    final userName = usernameController.text.trim();
    final pwd = passwordController.text;
    if (userName.isEmpty || pwd.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both username and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final user = _users.firstWhereOrNull(
      (u) => u.username == userName && u.password == pwd,
    );

    if (user == null) {
      Get.snackbar(
        'Login Failed',
        'Invalid username or password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'Success',
      'Welcome, ${user.username}',
      snackPosition: SnackPosition.BOTTOM,
    );

    // Debug print to check the user role
    print('User role: ${user.role}');

    // Navigate to role-specific screen
    switch (user.role) {
      case 'waiter':
        print('Navigating to waiter screen');
        Get.offAllNamed(AppRoutes.waiter);
        break;
      case 'chef':
        print('Navigating to chef screen');
        Get.offAllNamed(AppRoutes.chef);
        break;
      default:
        print('Navigating to login screen');

    }
  }

  /// Forgot password placeholder
  void forgotPassword() {
    Get.snackbar(
      'Forgot Password',
      'Password reset functionality will be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Fetch current location and reverse-geocode
  /// Fetch current location and reverse-geocode
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Location Disabled', 'Please enable location services.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied',
          'Location permissions are permanently denied.',
        );
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // // Print all position details
      // print('Position: Latitude=${position.latitude}, Longitude=${position.longitude}');
      // print('Accuracy: ${position.accuracy}');
      // print('Altitude: ${position.altitude}');
      // print('Speed: ${position.speed}');
      // print('Speed Accuracy: ${position.speedAccuracy}');
      // print('Heading: ${position.heading}');
      // print('Timestamp: ${position.timestamp}');

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        // // Print all placemark details
        // print('Placemark: Name=${place.name}');
        // print('Street: ${place.street}');
        // print('ISO Country Code: ${place.isoCountryCode}');
        // print('Country: ${place.country}');
        // print('Postal Code: ${place.postalCode}');
        // print('Administrative Area: ${place.administrativeArea}');
        // print('Sub Administrative Area: ${place.subAdministrativeArea}');
        // print('Locality: ${place.locality}');
        // print('Sub Locality: ${place.subLocality}');
        // print('Thoroughfare: ${place.thoroughfare}');
        // print('Sub Thoroughfare: ${place.subThoroughfare}');

        currentAddress.value =
            '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      } else {
        currentAddress.value = 'No placemarks found';
      }
    } catch (e) {
      currentAddress.value = 'Failed to get location';
      print('Error: $e');
    }
  }
}
