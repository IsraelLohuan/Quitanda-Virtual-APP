import 'package:greengrocer/src/constants/endpoint.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/cart/cart_result/cart_result.dart';
import 'package:greengrocer/src/services/http_manager.dart';

class CartRepository {
  final _httpManager = HttpManager();

  Future<CartResult<List<CartItemModel>>> getCartItems({
    required String token, 
    required String userId
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoint.getCartItems, 
      method: HttpMethods.post,
      headers: {
        'X-Parse-Session-Token': token
      },
      body: {
        'user': userId
      }
    );

    if(result['result'] != null) {
      List<CartItemModel> data = List<Map<String, dynamic>>.from(result['result']).map(CartItemModel.fromJson).toList();
      return CartResult<List<CartItemModel>>.sucess(data);
    } else {
      return CartResult.error('Ocorreu um erro ao recuperar os itens do carrinho!');
    }
  }

  Future<bool> changeItemQuantity({
    required String token,
    required String cartItemId,
    required int quantity
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoint.changeItemQuantity, 
      method: HttpMethods.post,
      body: {
        'cartItemId': cartItemId,
        'quantity': quantity
      },
      headers: {
        'X-Parse-Session-Token': token
      }
    );

    return result.isEmpty;
  }

  Future<CartResult<String>> addItemToCart({
    required String userId, 
    required String token, 
    required String productId, 
    required int quantity
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoint.addItemToCart, 
      method: HttpMethods.post,
      body: {
        "user": userId, 
        "quantity": quantity, 
        "productId": productId
      },
      headers: {
        'X-Parse-Session-Token': token
      }
    );

    if(result['result'] != null) {
      return CartResult.sucess(result['result']['id']);
    } else {
      return CartResult.error('N??o foi poss??vel adicionar o item no carrinho');
    }
  }

  Future<CartResult<OrderModel>> checkoutCart({required String token, required double total}) async {
    final result = await _httpManager.restRequest(
      url: Endpoint.checkout, 
      method: HttpMethods.post,
      body: {
        'total': total
      },
      headers: {
        'X-Parse-Session-Token': token
      }
    );

    if(result['result'] != null) {
      return CartResult.sucess(OrderModel.fromJson(result['result']));
    } else {
      return CartResult.error('N??o foi poss??vel realizar o pedido');
    }
  }
}