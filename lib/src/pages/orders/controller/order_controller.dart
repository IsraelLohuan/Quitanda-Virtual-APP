import 'package:get/get.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/auth/controller/auth_controller.dart';
import 'package:greengrocer/src/pages/orders/orders_result/orders_result.dart';
import 'package:greengrocer/src/pages/orders/repository/orders_repository.dart';
import 'package:greengrocer/src/services/utils_services.dart';

class OrderController extends GetxController { 
  final OrderModel order;
  final ordersRepository = OrdersRepository();
  final authController = Get.find<AuthController>();
  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;
    update();
  }

  OrderController(this.order);

  Future<void> getOrdersItems() async {
    setLoading(true);

    final OrdersResult<List<CartItemModel>> result = await ordersRepository.getOrderItems(
      orderId: order.id, 
      token: authController.user.token!
    );

    setLoading(false);
    
    result.when(
      sucess: (items) {
        order.items = items;
        update();
      }, 
      error: (message) {
        UtilsServices.showToast(message: message, isError: true);
      }
    );
  } 
}