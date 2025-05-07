// lib/view/homepage/home_page.dart
import 'package:flutter/material.dart';
import '../main_scaffold.dart';
import '../../Component/WaiterHomePage/table_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainScaffold(content: TableView());
  }
}
