import 'package:get/get.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/orders/repository/orders_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

import '../orders_result/orders_result.dart';

class AllOrdersController extends GetxController {
  List<OrderModel> allOrders = [];
  final OrdersRepository ordersRepository = OrdersRepository();
  final AuthController authController = Get.find<AuthController>();

  @override 
  void onInit() {
    super.onInit();
    getAllOrders();
  }

  Future<void> getAllOrders() async {
    OrdersResult<List<OrderModel>> result = await ordersRepository.getAllOrders(
      userId: authController.user.id!, 
      token: authController.user.token!
    );

    result.when(
      sucess: (orders) {
        allOrders = orders;
        update();
      }, 
      error: (message) {
        UtilsServices.showToast(message: message, isError: true);
      }
    );
  }
}