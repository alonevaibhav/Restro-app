import 'package:flutter/cupertino.dart';

import '../../Component/ChifHomePgae/home_chef.dart';
import '../../Component/WaiterHomePage/table_view.dart';
import '../main_scaffold.dart';

class ChefHome extends StatelessWidget {
  const ChefHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  MainScaffold(content: ChefPage());
  }
}
