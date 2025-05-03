import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w), // Use .w for responsive width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h), // Use .h for responsive height
                _buildHeader(controller),
                SizedBox(height: 60.h), // Use .h for responsive height
                _buildLoginCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(LoginController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome!',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Obx(() => Text(
          controller.currentAddress.value,
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black54,
            fontWeight: FontWeight.bold,

          ),
        )),
      ],
    );
  }


  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F7),
        borderRadius: BorderRadius.circular(8.w), // Use .w for responsive border radius
      ),
      padding: EdgeInsets.all(24.w), // Use .w for responsive padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'welcome back',
                  style: TextStyle(
                    fontSize: 20.sp, // Use .sp for responsive text size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'please enter your details',
                  style: TextStyle(
                    fontSize: 14.sp, // Use .sp for responsive text size
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h), // Use .h for responsive height
          _buildUsernameField(),
          SizedBox(height: 16.h), // Use .h for responsive height
          _buildPasswordField(),
          SizedBox(height: 8.h), // Use .h for responsive height
          _buildRememberForgot(),
          SizedBox(height: 24.h), // Use .h for responsive height
          _buildSignInButton(),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'username :',
          style: TextStyle(
            fontSize: 14.sp, // Use .sp for responsive text size
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h), // Use .h for responsive height
        TextField(
          controller: controller.usernameController,
          decoration: InputDecoration(
            hintText: 'Enter Given Username',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w), // Use .w for responsive border radius
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.w), // Use .w for responsive border radius
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h), // Use .w and .h for responsive padding
          ),
          style: TextStyle(fontSize: 14.sp), // Use .sp for responsive text size
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'password :',
          style: TextStyle(
            fontSize: 14.sp, // Use .sp for responsive text size
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h), // Use .h for responsive height
        Obx(
              () => TextField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            decoration: InputDecoration(
              hintText: 'Enter Your Password',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w), // Use .w for responsive border radius
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.w), // Use .w for responsive border radius
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h), // Use .w and .h for responsive padding
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
            ),
            style: TextStyle(fontSize: 14.sp), // Use .sp for responsive text size
          ),
        ),
      ],
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(
                  () => SizedBox(
                width: 20.w, // Use .w for responsive size
                height: 20.h, // Use .h for responsive size
                child: Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: (_) => controller.toggleRememberMe(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.w), // Use .w for responsive border radius
                  ),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
              ),
            ),
            SizedBox(width: 8.w), // Use .w for responsive width
            Text(
              'remember me',
              style: TextStyle(fontSize: 12.sp), // Use .sp for responsive text size
            ),
          ],
        ),
        GestureDetector(
          onTap: controller.forgotPassword,
          child: Text(
            'forget password ?',
            style: TextStyle(
              fontSize: 12.sp, // Use .sp for responsive text size
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.signIn,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF4169E8),
          padding: EdgeInsets.symmetric(vertical: 12.h), // Use .h for responsive vertical padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.w), // Use .w for responsive border radius
          ),
          elevation: 0,
        ),
        child: Text(
          'sign in',
          style: TextStyle(
            fontSize: 16.sp, // Use .sp for responsive text size
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
