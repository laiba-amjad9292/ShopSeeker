import 'package:get/get.dart';
import 'package:shop_seeker/modules/bottom_navbar/controllers/bottom_nav.controller.dart';
import 'package:shop_seeker/modules/home/controller/shop.controller.dart';
import 'package:shop_seeker/services/user_manager.service.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserManager(), fenix: true);
    Get.lazyPut(() => BottomNavigationController(), fenix: true);

    // Get.lazyPut(() => OrderController());
  }
}
