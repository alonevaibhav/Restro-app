//
// // FILE: lib/app/modules/login/controllers/login_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class LoginController extends GetxController {
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final rememberMe = false.obs;
//   final isPasswordVisible = false.obs;
//
//   @override
//   void onClose() {
//     usernameController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }
//
//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }
//
//   void toggleRememberMe() {
//     rememberMe.value = !rememberMe.value;
//   }
//
//   void signIn() {
//     // Implement your sign in logic here
//     if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please enter both username and password',
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }
//
//     // For demonstration purposes, just show a success message
//     Get.snackbar(
//       'Success',
//       'Login successful',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
//
//   void forgotPassword() {
//     // Implement your forgot password logic here
//     Get.snackbar(
//       'Forgot Password',
//       'Password reset functionality will be implemented here',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../RouteManager/app_routes.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final rememberMe = false.obs;
  final isPasswordVisible = false.obs;

  var currentAddress = ''.obs;

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

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  void signIn() {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {

      Get.snackbar(
        'Error',
        'Please enter both username and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      'Success',
      'Login successful',
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.offAllNamed(AppRoutes.homepage);

  }

  void forgotPassword() {
    Get.snackbar(
      'Forgot Password',
      'Password reset functionality will be implemented here',
      snackPosition: SnackPosition.BOTTOM,
    );
  }


  // Location
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
        Get.snackbar('Permission Denied', 'Location permissions are permanently denied.');
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;

      currentAddress.value = '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    } catch (e) {
      currentAddress.value = 'Failed to get location';
    }
  }


}
