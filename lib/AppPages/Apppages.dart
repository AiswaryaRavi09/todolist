import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:todoapp/Controller/HomeScreenController.dart';
import 'package:todoapp/View/HomeScreenView.dart';

import '../AppRoute/approute.dart';

class AppPages {
  static List<GetPage> appPages = <GetPage>[
  GetPage(
  name: AppRoute.homescreen,
  page: () =>  HomeScreenView(),
  ),
  ];
}