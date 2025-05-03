// // FILE: lib/app/widgets/hotel_header.dart
// import 'package:flutter/material.dart';
// import '../../Controller/sidebar_controller.dart';
//
// class HotelHeader extends StatelessWidget {
//   final SidebarController sidebarController;
//   final String phoneNumber;
//
//   const HotelHeader({
//     Key? key,
//     required this.sidebarController,
//     this.phoneNumber = "(406) 555-0120",
//   }) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       color: Colors.white,
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.menu, size: 28),
//             onPressed: () => sidebarController.toggleSidebar(),
//             padding: EdgeInsets.zero,
//             constraints: const BoxConstraints(),
//           ),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Alpani Hotel',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               Text(
//                 '2972 Westheimer Rd. Santa Ana, Illinois 85486',
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           ),
//           const Spacer(),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Row(
//                 children: [
//                   Text(
//                     'Id: ',
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     phoneNumber,
//                     style: TextStyle(
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF0A6EBD),
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   minimumSize: Size(0, 30),
//                 ),
//                 child: const Text(
//                   'logout',
//                   style: TextStyle(color: Colors.white, fontSize: 12),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/sidebar_controller.dart';

class HotelHeader extends StatelessWidget {
  HotelHeader({Key? key}) : super(key: key);
  final sidebarController = Get.find<SidebarController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, size: 28,),
            onPressed: sidebarController.toggleSidebar,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Alpani Hotel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('2972 Westheimer Rd. Santa Ana, Illinois 85486',
                    style: TextStyle(fontSize: 9, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              // Text('Id: (406) 555-0120', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              SizedBox(height: 4),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}