import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'API Service/api_client.dart';
import 'RouteManager/app_bindings.dart';
import 'RouteManager/app_routes.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init(); // 🔐 Required for shared_preferences
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),  // Set base design size (e.g., 360x690)
      minTextAdapt: true,           // Automatically adjust text sizes
      splitScreenMode: true,        // Handle split screen mode
      builder: (context, child) => GetMaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        title: 'Restaurant App',
        initialRoute: AppRoutes.login, // Define the initial route
        getPages: AppRoutes.routes, // Add routes from AppRoutes file
        initialBinding: AppBindings(), // Set up initial bindings
      ),
    );
  }
}
