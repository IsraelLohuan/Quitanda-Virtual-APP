import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:greengrocer/src/models/cart_item_model.dart';
import 'package:greengrocer/src/models/order_model.dart';
import 'package:greengrocer/src/pages/common_widgets/payment_dialog.dart';
import 'package:greengrocer/src/pages/orders/controller/order_controller.dart';
import 'package:greengrocer/src/services/utils_services.dart';

import 'order_status_widget.dart';

class OrderTile extends StatelessWidget {
  final OrderModel order;

  const OrderTile({ Key? key, required this.order }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: GetBuilder<OrderController>(
          init: OrderController(order),
          global: false,
          builder: (controller) { 
            return ExpansionTile(
              onExpansionChanged: (value) {
                if(value && order.items.isEmpty) {
                  controller.getOrdersItems();
                }
              },
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pedido: ${order.id}'),
                  Text(
                    UtilsServices.formatDateTime(order.createdDateTime!),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black
                    ),
                  ),
                ],
              ),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
              children: controller.isLoading ? [
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: const  CircularProgressIndicator(),
                )
              ] : [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 150,
                          child: ListView(
                            children: order.items.map<Widget>((orderItem) => _OrderItemWidget(orderItem: orderItem,),).toList(),
                          ),
                        )
                      ),
                      VerticalDivider(
                        color: Colors.grey.shade300,
                        thickness: 2,
                        width: 8,
                      ),
                      Expanded(
                        flex: 2,
                        child: OrderStatusWidget(
                            status: order.status,
                            isOverdue: order.overdueDateTime.isBefore(DateTime.now()),
                          )
                        )
                      ],
                    ),
                  ),
        
                  Text.rich(
                    TextSpan(
                      style: const TextStyle(fontSize: 20),
                      children: [
                        const TextSpan(
                          text: 'Total ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(text: UtilsServices.priceToCurrecy(order.total))
                      ]
                    )
                  ),
        
                  Visibility(
                    visible: order.status == 'pending_payment' && !order.isOverDue,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        )
                      ),
                      onPressed: () {
                        showDialog(
                          context: Get.context!, 
                          builder: (_) {
                              return PaymentDialog(order: order,);
                          }
                        );
                      }, 
                      icon: Image.asset('assets/app_images/pix.png', height: 10,), 
                      label: const Text('Ver QR Code Pix')
                    ),
                  )
                ],
              );
            },
          )
      ),
    );
  }
}

class _OrderItemWidget extends StatelessWidget {
  final CartItemModel orderItem;

  const _OrderItemWidget({
    Key? key,
    required this.orderItem
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '${orderItem.quantity} ${orderItem.item.unit} ', 
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              orderItem.item.itemName
            ),
          ),
          Text(
            UtilsServices.priceToCurrecy(orderItem.totalPrice())
          )
        ],
      ),
    );
  }
}